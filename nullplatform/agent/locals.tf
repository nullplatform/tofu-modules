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
  final_repo_list = distinct(concat(local.scope_list, local.repos_extra))

  agent_repos = join(",", local.final_repo_list)
  tags        = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])
  api_key     = nullplatform_api_key.nullplatform_agent_api_key.api_key

  default_args = [
    "--tags=$(TAGS)",
    "--apikey=$(NP_API_KEY)",
    "--runtime=host",
    "--command-executor-env=NP_API_KEY=$(NP_API_KEY)",
    "--command-executor-debug",
    "--webserver-enabled",
    "--command-executor-git-command-repos $(AGENT_REPOS)"
  ]

  cloud_args = {
    aws   = []
    gcp   = []
    azure = []
  }

  all_args = concat(local.default_args, lookup(local.cloud_args, var.cloud_provider, []))

  default_config = {
    NP_API_KEY   = local.api_key
    TAGS         = local.tags
    AGENT_REPOS  = local.agent_repos
    CLUSTER_NAME = var.cluster_name
    NAMESPACE    = var.namespace
    IMAGE_TAG    = var.image_tag
  }

  cloud_config = {
    aws = {
      AWS_IAM_ROLE_ARN = var.aws_iam_role_arn
    }

    gcp = {}

    azure = {
      PRIVATE_HOSTED_ZONE_RG  = var.private_hosted_zone_rg
      PRIVATE_GATEWAY_NAME    = var.private_gateway_name
      PUBLIC_GATEWAY_NAME     = var.public_gateway_name
      RESOURCE_GROUP          = var.azure_resource_group
      AZURE_SUBSCRIPTION_ID   = var.azure_subscription_id
      AZURE_CLIENT_SECRET     = var.azure_client_secret
      AZURE_CLIENT_ID         = var.azure_client_id
      AZURE_TENANT_ID         = var.azure_tenant_id
      DNS_TYPE                = var.dns_type
      USE_ACCOUNT_SLUG        = false
      image_pull_secrets      = "{\"ENABLED\": false}"
      DOMAIN                  = var.domain
      SERVICE_TEMPLATE        = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
      INITIAL_INGRESS_PATH    = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
      BLUE_GREEN_INGRESS_PATH = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
    }
  }
  all_config = merge(local.default_config, lookup(local.cloud_config, var.cloud_provider, {}))

  # Template único y simple
  nullplatform_agent_values = templatefile("${path.module}/templates/nullplatform_agent_values.tmpl.yaml", {
    args             = local.all_args
    config_values    = local.all_config
    image_tag        = var.image_tag
    aws_iam_role_arn = var.cloud_provider == "aws" ? var.aws_iam_role_arn : null
    init_scripts     = var.init_scripts
  })
}