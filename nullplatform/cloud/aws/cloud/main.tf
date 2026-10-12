resource "nullplatform_provider_config" "aws" {
  provider   = nullplatform
  nrn        = var.nrn
  type       = "aws-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    account    = local.account
    networking = local.networking
  })
}
