resource "nullplatform_provider_config" "scope_configuration" {
  nrn        = var.nrn
  type       = "static-files"
  dimensions = var.dimensions

  attributes = jsonencode(merge(local.defaults, local.overrides))
}
