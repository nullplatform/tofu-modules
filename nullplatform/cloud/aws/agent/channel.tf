################################################################################
# Notification Channel Resource
################################################################################
# Create notification channel with agent configuration and optional overrides
resource "nullplatform_notification_channel" "from_template" {
  nrn    = var.nrn
  type   = local.notification_channel_def.type
  source = local.notification_channel_def.source
  configuration {
    # Only configure agent block when notification channel type is "agent"
    dynamic "agent" {
      for_each = local.notification_channel_def.type == "agent" ? [local.notification_channel_def.configuration] : []
      content {
        api_key = agent.value.api_key
        command {
          type = agent.value.command.type
          # Merge command data with conditional cmdline override flag injection
          data = {
            for k, v in agent.value.command.data :
            k => (
              k == "environment"
              ? jsonencode({
                  NP_ACTION_CONTEXT = "'$${NOTIFICATION_CONTEXT}'"
                })
              : (k == "cmdline" && var.enabled_override
                ? "${tostring(v)} ${local.overrides_flag}"
                : (can(tostring(v)) ? tostring(v) : jsonencode(v))
              )
            )
            if k != "args"
          }
        }
        selector = var.tags_selectors
      }
    }
  }
  # Preserve existing filters if defined in template
  filters = can(local.notification_channel_def.filters) ? jsonencode(local.notification_channel_def.filters) : null
}