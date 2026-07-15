resource "terraform_data" "api_key_trigger" {
  input = var.api_key
}

resource "nullplatform_notification_channel" "from_template" {
  nrn         = var.nrn
  type        = "agent"
  source      = ["parameters"]
  description = var.description
  configuration {
    agent {
      api_key  = var.api_key
      selector = var.tags_selectors
      command {
        type = "exec"
        data = {
          "cmdline" : var.script_path
          "environment" : jsonencode({
            NP_ACTION_CONTEXT = "'$${NOTIFICATION_CONTEXT}'"
          })
        }
      }
    }
  }
  lifecycle {
    replace_triggered_by = [terraform_data.api_key_trigger]
  }
}
