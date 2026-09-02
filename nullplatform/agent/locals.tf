################################################################################
# Agent repository configuration
################################################################################

locals {

  tags        = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])

  api_key = var.api_key

  default_args = [
    "--tags=$(TAGS)",
    "--apikey=$(NP_API_KEY)",
    "--runtime=host",
    "--command-executor-env=NP_API_KEY=$(NP_API_KEY)",
    "--command-executor-debug",
    "--webserver-enabled",
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
    IMAGE_TAG               = var.image_tag
  }

  cloud_config = {
    aws = {
      AWS_IAM_ROLE_ARN = var.aws_iam_role_arn
    }

    gcp = {}
    azure = {}
    oci = {}
  }


  all_config = merge(
    local.default_config,
    lookup(local.cloud_config, var.cloud_provider, {}),
    var.extra_envs,
  )


  worker_default_env = {
    DNS_TYPE                = var.dns_type
    DOMAIN                  = var.domain
    USE_ACCOUNT_SLUG        = var.use_account_slug
    K8S_NAMESPACE           = var.namespace
    SERVICE_TEMPLATE        = var.service_template
    INITIAL_INGRESS_PATH    = var.initial_ingress_path
    BLUE_GREEN_INGRESS_PATH = var.blue_green_ingress_path
    TRAFFIC_CONTAINER_IMAGE = "${var.agent_traffic_manager_repository}:${var.agent_traffic_manager_tag}"
    IMAGE_PULL_SECRETS      = var.image_pull_secrets
    PRIVATE_GATEWAY_NAME    = var.private_gateway_name
    PUBLIC_GATEWAY_NAME     = var.public_gateway_name

  }

  worker_cloud_config = {
    azure = {
      PRIVATE_HOSTED_ZONE_RG = var.private_hosted_zone_rg
      RESOURCE_GROUP         = var.azure_resource_group
      AZURE_SUBSCRIPTION_ID  = var.azure_subscription_id
      AZURE_CLIENT_SECRET    = var.azure_client_secret
      AZURE_CLIENT_ID        = var.azure_client_id
      AZURE_TENANT_ID        = var.azure_tenant_id
    }
  }


  worker_all_config = merge(
    local.worker_default_env,
    lookup(local.worker_cloud_config, var.cloud_provider, {}),
    var.extra_envs,
  )

  worker_container_patch = {
    target = { package = "containers" }
    merge = {
      spec = merge(
        var.service_account_name != "" ? { serviceAccountName = var.service_account_name } : {},
        {
          containers = [
            {
              name      = "worker"
              resources = { limits = { memory = "2Gi" } }
              env       = [for k, v in local.worker_all_config : { name = k, value = v }]
            }
          ]
        }
      )
    }
  }
  
  worker_defaults = {
    backend           = "kubernetes"
    allowedRegistries = ["public.ecr.aws/nullplatform/*"]
    patches           = [local.worker_container_patch]
  }

  worker_final = merge(
    local.worker_defaults,
    try({ for k, v in var.worker : k => v if !contains(["patches", "allowedRegistries"], k) }, {}),
    {
      patches           = concat(local.worker_defaults.patches, try(var.worker.patches, []))
      allowedRegistries = distinct(concat(local.worker_defaults.allowedRegistries, try(var.worker.allowedRegistries, [])))
    }
  )

  # Single combined values document — worker is just another top-level key
  # of the same agent chart values, not a second Helm values layer.
  nullplatform_agent_values = templatefile("${path.module}/templates/nullplatform_agent_values.tmpl.yaml", {
    args                 = local.all_args
    config_values        = local.all_config
    image_tag            = var.image_tag
    image_repository     = var.image_repository
    aws_iam_role_arn     = var.cloud_provider == "aws" ? var.aws_iam_role_arn : ""
    init_scripts         = var.init_scripts
    service_account_name = var.service_account_name
    worker               = local.worker_final
  })
}
