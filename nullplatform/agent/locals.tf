################################################################################
# Agent repository configuration
################################################################################

locals {

  # The repository lives here and only the tag is exposed, so a version bump is a variable

  # change instead of a hand-assembled URL.

  scope_repo = trimspace(coalesce(var.agent_repos_scope, ""))

  scope_list = compact([local.scope_repo != "" ? "${local.scope_repo}#${trimspace(var.agent_repos_scope_tag)}" : ""])
  # Parse comma-separated extra repositories and clean whitespace
  repos_extra = compact([for s in var.agent_repos_extra : trimspace(s)])

  # Merge scope and extra repositories, removing duplicates
  final_repo_list = distinct(concat(local.scope_list, local.repos_extra))

  agent_repos = join(",", local.final_repo_list)
  tags        = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])

  api_key = var.api_key

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
    oci   = []
  }

  all_args = concat(local.default_args, lookup(local.cloud_args, var.cloud_provider, []))

  default_config = {
    NP_API_KEY              = local.api_key
    TAGS                    = local.tags
    AGENT_REPOS             = local.agent_repos
    CLUSTER_NAME            = var.cluster_name
    NAMESPACE               = var.namespace
    IMAGE_TAG               = var.image_tag
    TRAFFIC_CONTAINER_IMAGE = "${var.agent_traffic_manager_repository}:${var.agent_traffic_manager_tag}"
    IMAGE_PULL_SECRETS      = var.image_pull_secrets
    PRIVATE_GATEWAY_NAME    = var.private_gateway_name
    PUBLIC_GATEWAY_NAME     = var.public_gateway_name
  }

  cloud_config = {
    aws = {
      AWS_IAM_ROLE_ARN = var.aws_iam_role_arn
    }

    azure = {
      PRIVATE_HOSTED_ZONE_RG = var.private_hosted_zone_rg
      RESOURCE_GROUP         = var.azure_resource_group
      AZURE_SUBSCRIPTION_ID  = var.azure_subscription_id
      AZURE_CLIENT_SECRET    = var.azure_client_secret
      AZURE_CLIENT_ID        = var.azure_client_id
      AZURE_TENANT_ID        = var.azure_tenant_id
    }

    oci = {}
  }

  all_config = merge(
    local.default_config,
    lookup(local.cloud_config, var.cloud_provider, {}),
    var.extra_envs,
  )

  # Template único y simple
  nullplatform_agent_values = templatefile("${path.module}/templates/nullplatform_agent_values.tmpl.yaml", {
    args                 = local.all_args
    config_values        = local.all_config
    image_tag            = var.image_tag
    image_repository     = var.image_repository
    aws_iam_role_arn     = var.cloud_provider == "aws" ? var.aws_iam_role_arn : ""
    init_scripts         = var.init_scripts
    service_account_name = var.service_account_name
  })

  # Deploy-template/DNS values consumed by the worker when it renders a scope's
  # k8s deployment, not by the agent's own control loop.
  worker_env = {
    DNS_TYPE                = var.dns_type
    DOMAIN                  = var.domain
    USE_ACCOUNT_SLUG        = var.use_account_slug
    K8S_NAMESPACE           = var.namespace
    CLUSTER_NAME            = var.cluster_name
    SERVICE_TEMPLATE        = var.service_template
    INITIAL_INGRESS_PATH    = var.initial_ingress_path
    BLUE_GREEN_INGRESS_PATH = var.blue_green_ingress_path
  }

  worker_service_account_name = var.service_account_name

  worker_container_patch = {
    target = { package = "containers" }
    merge = {
      spec = merge(
        local.worker_service_account_name != "" ? { serviceAccountName = local.worker_service_account_name } : {},
        {
          containers = [
            merge(
              { name = "worker" },
              var.worker_memory_limit != null ? { resources = { limits = { memory = var.worker_memory_limit } } } : {},
              { env = [for k, v in local.worker_env : { name = k, value = v }] }
            )
          ]
        }
      )
    }
  }

  # Computed base merged with var.worker as an extra/override layer, so the
  # escape hatch keeps working without dropping the computed worker-container
  # patch (patches are concatenated, not replaced).
  worker_base = merge(
    { backend = var.worker_backend },
    var.worker_allowed_registries != null ? { allowedRegistries = var.worker_allowed_registries } : {},
    { patches = concat([local.worker_container_patch], try(var.worker.patches, [])) }
  )

  worker_final = merge(
    local.worker_base,
    try({ for k, v in var.worker : k => v if k != "patches" }, {})
  )

  # Always emitted (unlike the agent's own values) so these env vars never
  # silently disappear for callers who don't otherwise set var.worker.
  worker_values = yamlencode({ worker = local.worker_final })
}
