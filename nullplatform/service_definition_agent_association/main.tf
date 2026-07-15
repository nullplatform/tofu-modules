
resource "terraform_data" "api_key_trigger" {
  input = var.api_key
}

resource "nullplatform_notification_channel" "channel_from_template" {
  nrn         = var.nrn
  type        = var.channel_type
  source      = var.channel_sources
  description = var.description


  configuration {
    agent {
      api_key = var.api_key
      command {
        type = "exec"
        data = {
          cmdline     = "${var.base_clone_path}/${var.repository_service_spec_repo}${var.service_path != "" ? "/${var.service_path}" : ""}/entrypoint/entrypoint"
          arguments   = jsonencode(var.agent_arguments)
          environment = jsonencode({ NP_ACTION_CONTEXT = "'$${NOTIFICATION_CONTEXT}'" })
        }
      }

      selector = var.tags_selectors
    }
  }

  filters = jsonencode({
    "$or" = [
      { "service.specification.slug" = { "$eq" : var.service_specification_slug } }
    ]
  })

  lifecycle {
    replace_triggered_by = [terraform_data.api_key_trigger]
  }
}
