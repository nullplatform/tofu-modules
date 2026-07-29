resource "nullplatform_provider_config" "parameter_store_configuration" {
  nrn        = var.nrn
  type       = "aws-secrets-manager"
  dimensions = var.dimensions

  attributes = jsonencode(merge(local.defaults, {
    sensibility = merge(local.defaults.sensibility, { applies_to = var.applies_to })
    setup       = merge(local.defaults.setup, { kms_key_id = var.kms_key_id })
  }))

  # TODO: unverified whether this is actually needed for nullplatform_provider_config —
  # pending a drift investigation against the live API (same class of issue found for
  # nullplatform_service_specification.attributes in scope_definition, see #438).
  lifecycle {
    ignore_changes = [attributes]
  }
}
