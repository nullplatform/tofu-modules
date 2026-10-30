locals {
  cluster = merge(
    {
      id        = var.cluster_name
      namespace = var.namespace_application_default
      location  = var.region
    },
    var.use_nullplatform_namespace ? { use_nullplatform_namespace = var.use_nullplatform_namespace } : {},
    var.namespace_strategy != "" ? { namespace_strategy = var.namespace_strategy } : {},
    length(var.namespace_bootstrap_resources) > 0 ? { namespace_bootstrap_resources = var.namespace_bootstrap_resources } : {},
  )

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
    cluster = local.cluster,
    gateway = {
      namespace    = var.gateway_namespace
      public_name  = var.public_gateway_name
      private_name = var.private_gateway_name
    }
    },
    length(local.naming) > 0 ? { naming = local.naming } : {},
  ))
}
