locals {
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

  naming = { for k, v in {
    strategy           = var.naming_strategy
    deployment_pattern = var.naming_deployment_pattern
    scope_pattern      = var.naming_scope_pattern
  } : k => v if v != "" }
}

resource "nullplatform_provider_config" "oke_config" {
  nrn = var.nrn

  type       = "oke"
  dimensions = var.dimensions
  attributes = jsonencode(merge({
    cluster = {
      id        = var.cluster_name
      namespace = var.namespace_application_default
      location  = var.region
    },
    gateway = merge({
      namespace    = var.gateway_namespace
      public_name  = var.public_gateway_name
      private_name = var.private_gateway_name
    }, local.service_to_service)
    },
    length(local.naming) > 0 ? { naming = local.naming } : {},
  ))
}
