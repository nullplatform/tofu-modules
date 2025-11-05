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
  nullplatform_agent_values_default = templatefile("${path.module}/templates/nullplatform_agent_values_default.tmpl.yaml", {
    agent_repos  = join(",", local.final_list)
    cluster_name = var.cluster_name
    tags         = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])
    init_scripts = var.init_scripts
    api_key      = nullplatform_api_key.nullplatform_agent_api_key.api_key
    namespace    = var.namespace
  })

  nullplatform_agent_values_aws = templatefile("${path.module}/templates/nullplatform_agent_values_aws.tmpl.yaml", {
    image_tag        = var.image_tag
    aws_iam_role_arn = var.aws_iam_role_arn
  })

  nullplatform_agent_values_gcp = templatefile("${path.module}/templates/nullplatform_agent_values_gcp.tmpl.yaml", {})

  nullplatform_agent_values_azure = templatefile("${path.module}/templates/nullplatform_agent_values_azure.tmpl.yaml", {
    api_key                = nullplatform_api_key.nullplatform_agent_api_key.api_key
    tags                   = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])
    agent_repos            = join(",", local.final_list)
    cluster_name           = var.cluster_name
    namespace              = var.namespace
    private_hosted_zone_rg = var.private_hosted_zone_rg
    private_gateway_name   = var.private_gateway_name
    public_gateway_name    = var.public_gateway_name
    azure_resource_group   = var.azure_resource_group
    azure_subscription_id  = var.azure_subscription_id
    azure_client_secret    = var.azure_client_secret
    azure_client_id        = var.azure_client_id
    azure_tenant_id        = var.azure_tenant_id
  })
}