locals {
  setup = {
    region      = data.aws_region.current.region
    role_arn    = var.application_role_arn
    naming_rule = var.naming_rule
    policy      = var.repository_policy
  }
}

resource "nullplatform_provider_config" "ecr" {
  provider = nullplatform
  nrn      = var.nrn
  type     = "ecr"
  attributes = jsonencode({
    ci    = {
      region     = data.aws_region.current.region
      access_key = var.build_workflow_access_key_id
      secret_key = var.build_workflow_access_key_secret
    }
    setup = local.setup
  })
}
