################################################################################
# Notification Channel Template Fetching
################################################################################

data "http" "notification_channel_template" {
  url = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads/main/${var.service_path}/specs/notification-channel.json.tpl"
}

################################################################################
# Notification Channel Processing
################################################################################

# Process notification channel template with service and API context
data "external" "notification_channel" {
  depends_on = [data.http.notification_channel_template]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.http.notification_channel_template.response_body)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${var.nrn}' \
    NP_API_KEY='${module.api_key.api_key}' \
    REPO_PATH='${var.repo_path}' \
    SERVICE_PATH='${var.service_path}' \
    SERVICE_SLUG='${var.scope_specification_slug}' \
    SERVICE_SPECIFICATION_ID='${var.scope_specification_id}' \
    gomplate)
    echo "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}