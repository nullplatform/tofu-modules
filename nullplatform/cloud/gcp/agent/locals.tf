locals {
  scope_list            = compact([trimspace(coalesce(var.agent_repos_scope, ""))])
  repos_extra           = compact([for s in split(",", try(coalesce(var.agent_repos_extra, ""), "")) : trimspace(s)])
  final_list            = distinct(concat(local.scope_list, local.repos_extra))
  nrn_without_namespace = join(":", slice(split(":", var.nrn), 0, 2))

  nullplatform_agent_values = templatefile("nullplatform_agent_values_default.tmpl.yaml", {
    agent_repos  = join(",", local.final_list)
    cluster_name = var.cluster_name
    tags         = var.tags
    init_scripts = var.init_scripts
    api_key      = nullplatform_api_key.nullplatform_agent_api_key.api_key
    namespace    = var.namespace
  })
}