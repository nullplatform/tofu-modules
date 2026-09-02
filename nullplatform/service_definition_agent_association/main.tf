
locals {
  worker_entrypoint = var.entrypoint != "" ? var.entrypoint : "/app/packages/${var.package_slug}/entrypoint"
}

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
        # Worker-orchestrator: route package-exec to an agent that spawns the
        # package's worker image and runs its baked entrypoint (matches
        # `np package publish`). Otherwise legacy git-clone exec.
        type = var.worker_orchestrator ? "package-exec" : "exec"
        data = var.worker_orchestrator ? {
          package = var.package_slug
          cmdline = local.worker_entrypoint
          environment = jsonencode({
            NP_ACTION_CONTEXT = "'$${NOTIFICATION_CONTEXT}'"
            NP_PLUGIN         = var.package_slug
          })
          } : {
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
    precondition {
      condition     = !var.worker_orchestrator || var.package_slug != ""
      error_message = "package_slug is required when worker_orchestrator = true."
    }
  }
}
