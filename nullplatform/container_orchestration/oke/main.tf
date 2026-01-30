resource "nullplatform_provider_config" "oke_config" {
  nrn = var.nrn

  type       = "oke"
  dimensions = var.dimensions
  attributes = jsonencode({
    cluster = {
      name      = var.cluster_name
      namespace = var.namespace_application_default
      location  = var.region
    },
    gateway = {
      namespace    = var.gateway_namespace
      public_name  = var.public_gateway_name
      private_name = var.private_gateway_name
    }
  })
}