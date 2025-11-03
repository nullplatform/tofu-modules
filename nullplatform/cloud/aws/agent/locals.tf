################################################################################
# Agent Repository Configuration
################################################################################

locals {
  # Parse and clean the primary scope repository
  scope_list = compact([trimspace(coalesce(var.agent_repos_scope, ""))])

  # Parse comma-separated extra repositories and clean whitespace
  repos_extra = compact([for s in split(",", try(coalesce(var.agent_repos_extra, ""), "")) : trimspace(s)])

  # Merge scope and extra repositories, removing duplicates
  final_list = distinct(concat(local.scope_list, local.repos_extra))

  # Render Helm values template with agent configuration
  nullplatform_agent_values = templatefile("nullplatform_agent_values_default.tmpl.yaml", {
    agent_repos       = join(",", local.final_list)
    cluster_name      = var.cluster_name
    tags              = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])
    init_scripts      = var.init_scripts
    resource_identity = module.nullplatform_agent_role.arn
    api_key           = nullplatform_api_key.nullplatform_agent_api_key.api_key
    namespace         = var.namespace
  })

  notification_channel_def = jsondecode(data.external.notification_channel.result.json)

  # Build overrides flag only when override feature is enabled
  overrides_flag = var.enabled_override ? "--overrides-path=${var.override_repo_path}${var.overrides_service_path}" : ""
}