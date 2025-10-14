################################################################################
# Notification Channel Template Fetching
################################################################################

# Fetch notification channel template from GitHub repository
data "http" "notification_channel_template" {
  url = "${var.github_repo_url}/raw/${var.github_ref}/${var.service_path}/specs/notification-channel.json.tpl"
}

################################################################################
# Notification Channel Processing
################################################################################

# Process notification channel template with service and API context
data "external" "notification_channel" {
  program = ["sh", "-c", <<-EOT
    processed_json=$(echo '${data.http.notification_channel_template.response_body}' | \
    NRN='${var.nrn}' \
    NP_API_KEY='${nullplatform_api_key.nullplatform_agent_api_key.api_key}' \
    REPO_PATH='${var.repo_path}' \
    SERVICE_PATH='${var.service_path}' \
    SERVICE_SLUG='${nullplatform_service_specification.from_template.slug}' \
    SERVICE_SPECIFICATION_ID='${nullplatform_service_specification.from_template.id}' \
    gomplate)
    echo "{\"json\":\"$(echo "$processed_json" | sed 's/"/\\"/g' | tr -d '\n')\"}"
  EOT
  ]
}