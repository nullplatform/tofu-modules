resource "nullplatform_provider_config" "aks_config" {
  nrn = var.nrn

  type       = "aks-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    cluster = {
      id                  = var.cluster_name
      resource_group      = var.resource_group
      namespace           = var.namespace_application_default
      authentication_mode = var.authentication_mode
    }
    gateway = {
      namespace    = var.gateway_namespace
      public_name  = var.public_gateway_name
      private_name = var.private_gateway_name
    }
    resource_management = {
      memory_cpu_ratio              = var.memory_cpu_ratio
      memory_request_to_limit_ratio = var.memory_request_to_limit_ratio
      max_cores_multiplier          = var.max_cores_multiplier
      max_milicores                 = var.max_milicores
    }
    security = {
      image_pull_secrets   = var.image_pull_secrets
      service_account_name = var.service_account_name
    }
    traffic_manager = {
      version = var.traffic_manager_version
    }
    object_modifiers = {
      modifiers = var.object_modifiers
    }
  })
}
