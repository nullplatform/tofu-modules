resource "nullplatform_provider_config" "aws" {
  provider   = nullplatform
  nrn        = var.nrn
  type       = "aws-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    account = {
      id     = data.aws_caller_identity.current.id
      region = data.aws_region.current.region
    }
    networking = local.networking
  })
}
