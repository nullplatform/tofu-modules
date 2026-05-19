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
    networking = {
      application_domain    = var.application_domain,
      domain_name           = var.domain_name
      hosted_zone_id        = var.hosted_private_zone_id
      hosted_public_zone_id = var.hosted_public_zone_id
    }
  })
}