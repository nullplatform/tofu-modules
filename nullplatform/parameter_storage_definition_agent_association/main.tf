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
        # Worker-orchestrator: route package-exec to an agent that spawns the
        # parameters worker image (nullplatform/services-parameters) and runs its
        # baked entrypoint, so parameter reads don't load the agent pod.
        # Otherwise legacy git-clone exec.
        type = var.worker_orchestrator ? "package-exec" : "exec"
        data = var.worker_orchestrator ? {
          package = var.package_slug
          cmdline = var.entrypoint
          environment = jsonencode({
            NP_ACTION_CONTEXT = "'$${NOTIFICATION_CONTEXT}'"
            NP_PLUGIN         = var.package_slug
          })
          } : {
          cmdline = var.script_path
          environment = jsonencode({
            NP_ACTION_CONTEXT = "'$${NOTIFICATION_CONTEXT}'"
          })
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = !var.worker_orchestrator || (var.package_slug != "" && var.entrypoint != "")
      error_message = "package_slug and entrypoint are required when worker_orchestrator = true."
    }
  }
}
