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

  attributes = merge(
    {
      cluster = local.cluster
    },
    length(local.balancer) > 0 ? { balancer = local.balancer } : {},
    length(local.network) > 0 ? { network = local.network } : {},
    length(local.resource_management) > 0 ? { resource_management = local.resource_management } : {},
    length(local.security) > 0 ? { security = local.security } : {},
    var.traffic_manager_version != "" ? { traffic_manager = { version = var.traffic_manager_version } } : {},
    length(var.object_modifiers) > 0 ? { object_modifiers = { modifiers = var.object_modifiers } } : {},
  )
}

resource "nullplatform_provider_config" "eks_config" {
  nrn = var.nrn

  type       = "eks-configuration"
  dimensions = var.dimensions
  attributes = jsonencode(local.attributes)
}
