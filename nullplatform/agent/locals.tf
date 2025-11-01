################################################################################
# Agent Repository Configuration
################################################################################

locals {
  # Parse and clean the primary scope repository
  nrn_without_namespace = join(":", slice(split(":", var.nrn), 0, 2))
  scope_list            = compact([trimspace(coalesce(var.agent_repos_scope, ""))])
  # Parse comma-separated extra repositories and clean whitespace
  repos_extra = compact([for s in split(",", try(coalesce(var.agent_repos_extra, ""), "")) : trimspace(s)])

  # Merge scope and extra repositories, removing duplicates
  final_list = distinct(concat(local.scope_list, local.repos_extra))

  # Render Helm values template with agent configuration
  nullplatform_agent_values = templatefile("${path.module}/templates/nullplatform_agent_values.tmpl.yaml", {
    agent_repos  = join(",", local.final_list)
    cluster_name = var.cluster_name
    tags         = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])
    init_scripts = var.init_scripts
    api_key      = nullplatform_api_key.nullplatform_agent_api_key.api_key
    namespace    = var.namespace

  })

}