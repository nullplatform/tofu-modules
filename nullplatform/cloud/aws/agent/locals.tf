locals {
  git_login = var.git_user != null && var.git_password !=null ? "${var.git_user}:${var.git_password}@" : var.git_user != null ? "${var.git_user}@" : ""
  full_git_repo_url = var.git_provider == "github" ? "https://${local.git_login}raw.githubusercontent.com/${var.git_repo}/refs/heads/${var.git_ref}" : null

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

  base_config = {
    nrn                      = var.nrn
    agent_tags               = var.agent_tags
    channel_sources          = var.channel_sources
    channel_type             = var.channel_type
    agent_api_key            = var.agent_api_key
    slug                     = var.scope_slug
    scope_provider_id        = var.scope_provider_id
    agent_command            = var.agent_command
    workflow_override_path   = var.workflow_override_path
    workflow_override_values = var.workflow_override_values
  }

  merged_config = merge(
    local.base_config,
    {
      for k, v in var.scope_definition : k => (
    # If key exists in base_config and scope_definition value is null,
    # keep the base_config value, otherwise use scope_definition value
      contains(keys(local.base_config), k) && v == null
      ? local.base_config[k]
      : v
    )
    }
  )
}