resource "nullplatform_provider_config" "scope_configuration" {
  nrn        = var.nrn
  type       = var.provider_specification_slug
  dimensions = var.dimensions
  attributes = jsonencode(var.attributes)

  lifecycle {
    ignore_changes = [attributes]
  }
}
