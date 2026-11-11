resource "nullplatform_provider_config" "scope_configuration" {
  nrn        = var.nrn
  type       = var.type
  dimensions = var.dimensions

  attributes = jsonencode(local.payload)
}
