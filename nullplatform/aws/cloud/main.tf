resource "nullplatform_provider_config" "aws" {
  provider   = nullplatform
  nrn        = var.nrn
  type       = "aws-configuration"
  dimensions = {}
  attributes = jsonencode({
    iam = {
      #scope_workflow_role = aws_iam_role.nullplatform_scope_workflow_role.arn
    }
    account = {
      id     = data.aws_caller_identity.current.id
      region = data.aws_region.current.region
    }
    networking = {
      application_domain    = false
      domain_name           = var.domain_name
      hosted_zone_id        = var.hosted_private_zone_id
      hosted_public_zone_id = var.hosted_public_zone_id
    }
  })
  lifecycle {
    ignore_changes = [attributes]
  }
}

