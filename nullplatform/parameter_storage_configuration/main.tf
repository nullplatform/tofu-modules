resource "nullplatform_provider_config" "parameter_store_configuration" {
  nrn        = var.nrn
  type       = var.type
  dimensions = var.dimensions

  attributes = jsonencode(merge(local.defaults, local.overrides))
}
