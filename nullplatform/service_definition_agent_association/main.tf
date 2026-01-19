
resource "nullplatform_notification_channel" "channel_from_template" {
  nrn    = var.nrn
  type   = var.channel_type
  source = var.channel_sources


  configuration {
    dynamic "agent" {
      for_each = var.agent_command != null ? [1] : []
      content {
        api_key = module.api_key.api_key
        command {
          type = var.agent_command.type
          data = {
            cmdline = join(" ", compact([
              var.agent_command.data.cmdline,
              var.workflow_override_path != null ? "--overrides-path=${var.workflow_override_path}" : "",
              var.service_path != null ? "--service-path=${var.service_path}" : "",
            ]))
            arguments   = jsonencode(try(var.agent_command.data.arguments, []))
            environment = jsonencode(try(var.agent_command.data.environment, {}))
          }
        }

        selector = var.tags_selectors
      }
    }
  }

  filters = jsonencode({
    "$or" = [
      { "service.specification.slug" = { "$eq" : var.service_slug } }
    ]
  })
}
