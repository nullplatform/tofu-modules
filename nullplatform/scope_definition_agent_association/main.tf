################################################################################
# Notification Channel Resource
################################################################################

resource "terraform_data" "api_key_trigger" {
  input = var.api_key
}

# Create notification channel with agent configuration and optional overrides
resource "nullplatform_notification_channel" "from_template" {
  nrn         = var.nrn
  type        = local.notification_channel_def.type
  source      = local.notification_channel_def.source
  description = var.description
  configuration {
    # Only configure agent block when notification channel type is "agent"
    dynamic "agent" {
      for_each = local.notification_channel_def.type == "agent" ? [local.notification_channel_def.configuration] : []
      content {
        api_key = agent.value.api_key
        command {
          # Worker-orchestrator: route package-exec to an agent that spawns the
          # package's worker image and runs its baked entrypoint (matches
          # `np package publish`). Otherwise pass the template's command through
          # (legacy git-clone exec).
          type = var.worker_orchestrator ? "package-exec" : agent.value.command.type
          data = var.worker_orchestrator ? {
            package = var.package_slug
            cmdline = local.worker_entrypoint
            environment = jsonencode({
              NP_ACTION_CONTEXT = "'$${NOTIFICATION_CONTEXT}'"
              NP_PLUGIN         = var.package_slug
            })
            } : {
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
  filters = local.merged_filters_json
  lifecycle {
    replace_triggered_by = [terraform_data.api_key_trigger]
    precondition {
      condition     = !var.worker_orchestrator || var.package_slug != ""
      error_message = "package_slug is required when worker_orchestrator = true."
    }
  }
}
