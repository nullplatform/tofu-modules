################################################################################
# Notification Channel Template Fetching
################################################################################

data "http" "notification_channel_template" {
  url = "${var.repository_notification_channel}/${var.repository_notification_channel_branch}/${var.service_path}/specs/notification-channel.json.tpl"
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
    NP_API_KEY='${var.api_key}' \
    REPO_PATH='${var.repo_path}' \
    SERVICE_PATH='${var.service_path}' \
    SERVICE_SLUG='${var.scope_specification_slug}' \
    SERVICE_SPECIFICATION_ID='${var.scope_specification_id}' \
    gomplate)
    printf '%s\n' "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}
