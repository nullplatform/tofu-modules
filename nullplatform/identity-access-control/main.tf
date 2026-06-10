resource "nullplatform_provider_config" "identity_access_control" {
  nrn        = var.nrn
  type       = var.type
  dimensions = var.dimensions
  attributes = jsonencode(var.attributes)
}
