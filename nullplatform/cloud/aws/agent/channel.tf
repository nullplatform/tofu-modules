################################################################################
# Step 1: Fetch Notification Channel Template
################################################################################

data "http" "notification_channel_template" {
  url = "${var.github_repo_url}/raw/${var.github_ref}/${var.service_path}/specs/notification-channel.json.tpl"
}

###############################################################################
#Step 2: Process and Create Notification Channel
###############################################################################

#Process notification channel template
data "external" "notification_channel" {
  program = ["sh", "-c", <<-EOT
    processed_json=$(echo '${data.http.notification_channel_template.response_body}' | \
    NRN='${var.nrn}' \
    NP_API_KEY='${nullplatform_api_key.nullplatform-agent-api-key.api_key}' \
    REPO_PATH='${var.repo_path}' \
    SERVICE_PATH='${var.service_path}' \
    ENVIRONMENT='${var.environment_tag}' \
    SERVICE_SLUG='${nullplatform_service_specification.from_template.slug}' \
    SERVICE_SPECIFICATION_ID='${nullplatform_service_specification.from_template.id}' \
    gomplate)
    echo "{\"json\":\"$(echo "$processed_json" | sed 's/"/\\"/g' | tr -d '\n')\"}"
  EOT
  ]
}

locals {
  notification_channel_def = jsondecode(data.external.notification_channel.result.json)
}

# Create notification channel
resource "nullplatform_notification_channel" "from_template" {
  nrn    = var.nrn
  type   = local.notification_channel_def.type
  source = local.notification_channel_def.source

  configuration {
    dynamic "agent" {
      for_each = local.notification_channel_def.type == "agent" ? [local.notification_channel_def.configuration] : []
      content {
        api_key = agent.value.api_key
        command {
          type = agent.value.command.type
          data = {
            for k, v in agent.value.command.data : k => (
              k == "environment" ? jsonencode({
                NP_ACTION_CONTEXT = "'$${NOTIFICATION_CONTEXT}'"
                }) : (
                can(tostring(v)) ? tostring(v) : jsonencode(v)
              )
            )
          }
        }
        selector = agent.value.selector
      }
    }
  }

  filters = can(local.notification_channel_def.filters) ? jsonencode(local.notification_channel_def.filters) : null
}