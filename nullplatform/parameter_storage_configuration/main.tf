resource "nullplatform_provider_config" "parameter_store_configuration" {
  nrn        = var.nrn
  type       = var.type
  dimensions = var.dimensions

  attributes = jsonencode(merge(local.defaults, {
    sensibility = merge(local.defaults.sensibility, { applies_to = var.applies_to })
    setup       = merge(local.defaults.setup, { kms_key_id = var.kms_key_id })
  }))
}
