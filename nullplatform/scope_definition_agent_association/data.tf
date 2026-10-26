################################################################################
# Notification Channel Template Fetching
################################################################################

# A non-2xx is not an error for the http provider: the body would render as the template.
# Skipped with var.local_specs_path: the template is read from disk (locals.tf).
data "http" "notification_channel_template" {
  count = var.local_specs_path != null ? 0 : 1
  url   = "${var.repository_notification_channel}/${var.repository_notification_channel_branch}/${var.service_path}/specs/notification-channel.json.tpl"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200."
    }
  }
}

################################################################################
# Notification Channel Processing
################################################################################

# Process notification channel template with service and API context
data "external" "notification_channel" {
  depends_on = [data.http.notification_channel_template]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(local.notification_channel_template)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${var.nrn}' \
    NP_API_KEY='${var.api_key == null ? "" : var.api_key}' \
    REPO_PATH='${var.repo_path}' \
    SERVICE_PATH='${var.service_path}' \
    SERVICE_SLUG='${var.scope_specification_slug}' \
    SERVICE_SPECIFICATION_ID='${var.scope_specification_id}' \
    gomplate)
    printf '%s\n' "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}
