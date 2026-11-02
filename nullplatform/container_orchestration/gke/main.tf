locals {
  cluster = merge(
    {
      id        = var.cluster_name
      location  = var.location
      namespace = var.namespace_application_default
    },
    var.use_nullplatform_namespace ? { use_nullplatform_namespace = var.use_nullplatform_namespace } : {},
    length(var.namespace_bootstrap_resources) > 0 ? { namespace_bootstrap_resources = var.namespace_bootstrap_resources } : {},
  )

  additional_gateways = merge(
    length(var.additional_public_gateways) > 0 ? {
      additional_public_gateways = [for gateway in var.additional_public_gateways : { for k, v in gateway : k => v if v != null }]
    } : {},
    length(var.additional_private_gateways) > 0 ? {
      additional_private_gateways = [for gateway in var.additional_private_gateways : { for k, v in gateway : k => v if v != null }]
    } : {},
  )

  gateway = merge(
    {
      public_name = var.public_gateway_name
    },
    var.gateway_namespace != "" ? { namespace = var.gateway_namespace } : {},
    var.private_gateway_name != "" ? { private_name = var.private_gateway_name } : {},
    local.additional_gateways,
  )

  resource_management = { for k, v in {
    memory_cpu_ratio              = var.memory_cpu_ratio
    memory_request_to_limit_ratio = var.memory_request_to_limit_ratio
    max_cores_multiplier          = var.max_cores_multiplier
    max_milicores                 = var.max_milicores
  } : k => v if v != "" }

  security = merge(
    length(var.image_pull_secrets) > 0 ? { image_pull_secrets = var.image_pull_secrets } : {},
    var.service_account_name != "" ? { service_account_name = var.service_account_name } : {},
  )

  naming = { for k, v in {
    strategy           = var.naming_strategy
    deployment_pattern = var.naming_deployment_pattern
    scope_pattern      = var.naming_scope_pattern
    namespace_pattern  = var.naming_namespace_pattern
  } : k => v if v != "" }

  attributes = merge(
    {
      cluster = local.cluster
      gateway = local.gateway
    },
    length(local.resource_management) > 0 ? { resource_management = local.resource_management } : {},
    length(local.security) > 0 ? { security = local.security } : {},
    { traffic_manager = { version = var.traffic_manager_version } },
    length(var.object_modifiers) > 0 ? { object_modifiers = { modifiers = var.object_modifiers } } : {},
    length(local.naming) > 0 ? { naming = local.naming } : {},
  )
}

resource "nullplatform_provider_config" "gke_config" {
  nrn = var.nrn

  type       = "gke-configuration"
  dimensions = var.dimensions
  attributes = jsonencode(local.attributes)
}
