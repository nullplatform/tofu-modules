locals {
  cluster = merge(
    {
      id             = var.cluster_name
      resource_group = var.resource_group
      namespace      = var.namespace_application_default
    },
    var.authentication_mode != "" ? { authentication_mode = var.authentication_mode } : {},
  )

  gateway = merge(
    {
      namespace   = var.gateway_namespace
      public_name = var.public_gateway_name
    },
    var.private_gateway_name != "" ? { private_name = var.private_gateway_name } : {},
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

  attributes = merge(
    {
      cluster = local.cluster
      gateway = local.gateway
    },
    length(local.resource_management) > 0 ? { resource_management = local.resource_management } : {},
    length(local.security) > 0 ? { security = local.security } : {},
    var.traffic_manager_version != "" ? { traffic_manager = { version = var.traffic_manager_version } } : {},
    length(var.object_modifiers) > 0 ? { object_modifiers = { modifiers = var.object_modifiers } } : {},
  )
}

resource "nullplatform_provider_config" "aks_config" {
  nrn = var.nrn

  type       = "aks-configuration"
  dimensions = var.dimensions
  attributes = jsonencode(local.attributes)
}
