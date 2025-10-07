resource "nullplatform_notification_channel" "channel_from_template" {
  nrn    = local.merged_config.nrn
  type   = "agent"
  source = local.merged_config.channel_sources
  

  configuration {
    dynamic "agent" {
      for_each = [1]
      content {
        api_key = local.merged_config.agent_api_key
        command {
          type = local.merged_config.specification.agent_command.type
          data = {
            cmdline = join(" ", compact([
              local.merged_config.specification.agent_command.data.cmdline,
              local.merged_config.workflow_override_path != null ? "--overrides-path=${local.merged_config.workflow_override_path}" : ""
            ]))
            arguments = jsonencode(try(local.merged_config.specification.agent_command.data.arguments, []))
            environment = jsonencode(try(local.merged_config.specification.agent_command.data.environment, {}))
          }
        }
      
        selector = local.merged_config.agent_tags
      }
    }
  }

  filters = jsonencode({
    "$or" = [
      {"service.specification.slug" = {"$eq": local.merged_config.slug }},
      {"arguments.scope_provider" = {"$eq": local.merged_config.scope_provider_id }}
    ]
  })
}
