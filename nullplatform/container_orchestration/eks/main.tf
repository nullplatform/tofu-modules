locals {
  cluster = merge(
    {
      id = var.cluster_name
    },
    var.namespace_application_default != "" ? { namespace = var.namespace_application_default } : {},
    var.use_nullplatform_namespace ? { use_nullplatform_namespace = var.use_nullplatform_namespace } : {},
  )

  balancer = merge(
    { for k, v in {
      public_name  = var.public_balancer_name
      private_name = var.private_balancer_name
    } : k => v if v != "" },
    var.alb_capacity_threshold != null ? { alb_capacity_threshold = var.alb_capacity_threshold } : {},
    length(var.additional_public_balancer_names) > 0 ? { additional_public_names = var.additional_public_balancer_names } : {},
    length(var.additional_private_balancer_names) > 0 ? { additional_private_names = var.additional_private_balancer_names } : {},
  )

  additional_gateways = merge(
    length(var.additional_public_gateways) > 0 ? {
      additional_public_gateways = [for gateway in var.additional_public_gateways : { for k, v in gateway : k => v if v != null }]
    } : {},
    length(var.additional_private_gateways) > 0 ? {
      additional_private_gateways = [for gateway in var.additional_private_gateways : { for k, v in gateway : k => v if v != null }]
    } : {},
  )

  service_to_service_set = merge(
    var.service_to_service_enabled != null ? { enabled = var.service_to_service_enabled } : {},
    { for k, v in {
      mode            = var.service_to_service_mode
      gateway_name    = var.service_to_service_gateway_name
      listener_prefix = var.service_to_service_listener_prefix
      cluster_domain  = var.service_to_service_cluster_domain
      name_pattern    = var.service_to_service_name_pattern
    } : k => v if v != "" },
  )

  service_to_service = length(local.service_to_service_set) > 0 ? {
    service_to_service = merge({ enabled = false, mode = "shared" }, local.service_to_service_set)
  } : {}

  gateway = merge(
    { for k, v in {
      namespace    = var.gateway_namespace
      public_name  = var.public_gateway_name
      private_name = var.private_gateway_name
    } : k => v if v != "" },
    local.additional_gateways,
    local.service_to_service,
  )

  network = { for k, v in {
    balancer_group_suffix = var.balancer_group_suffix
  } : k => v if v != "" }

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

  traffic_manager = merge(
    var.traffic_manager_version != "" ? { version = var.traffic_manager_version } : {},
    var.traffic_manager_port != null ? { port = var.traffic_manager_port } : {},
  )

  naming = { for k, v in {
    strategy           = var.naming_strategy
    deployment_pattern = var.naming_deployment_pattern
    scope_pattern      = var.naming_scope_pattern
  } : k => v if v != "" }

  attributes = merge(
    {
      cluster = local.cluster
    },
    length(local.balancer) > 0 ? { balancer = local.balancer } : {},
    length(local.gateway) > 0 ? { gateway = local.gateway } : {},
    length(local.network) > 0 ? { network = local.network } : {},
    length(local.resource_management) > 0 ? { resource_management = local.resource_management } : {},
    length(local.security) > 0 ? { security = local.security } : {},
    length(local.traffic_manager) > 0 ? { traffic_manager = local.traffic_manager } : {},
    length(var.object_modifiers) > 0 ? { object_modifiers = { modifiers = var.object_modifiers } } : {},
    length(local.naming) > 0 ? { naming = local.naming } : {},
  )
}

resource "nullplatform_provider_config" "eks_config" {
  nrn = var.nrn

  type       = "eks-configuration"
  dimensions = var.dimensions
  attributes = jsonencode(local.attributes)
}
