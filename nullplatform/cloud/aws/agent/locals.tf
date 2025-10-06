locals {
  scope_list  = compact([trimspace(coalesce(var.agent_repos_scope, ""))])
  repos_extra = compact([for s in split(",", try(coalesce(var.agent_repos_extra, ""), "")) : trimspace(s)])
  final_list  = distinct(concat(local.scope_list, local.repos_extra))

  nullplatform_agent_values = templatefile("${path.module}/templates/nullplatform-agent-values.tmpl.yaml", {
    agent_repos       = join(",", local.final_list)
    cluster_name      = var.cluster_name
    tags              = var.tags
    init_scripts      = var.init_scripts
    resource_identity = module.nullplatform-agent-role.arn
    api_key           = nullplatform_api_key.nullplatform-agent-api-key.api_key
    namespace         = var.namespace
  })
}