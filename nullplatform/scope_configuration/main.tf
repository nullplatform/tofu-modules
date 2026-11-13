resource "nullplatform_provider_config" "scope_configuration" {
  nrn        = var.nrn
  type       = coalesce(var.specification_slug, var.type)
  dimensions = var.dimensions

  attributes = jsonencode(local.payload)
}
