locals {
  has_build_workflow_keys = var.build_workflow_access_key_id != null && var.build_workflow_access_key_secret != null

  # Only the credential sources actually configured reach the provider. The
  # specification forbids unknown keys, and a null role_arn or access_key would
  # fail its pattern validation.
  ci = merge(
    { region = data.aws_region.current.region },
    var.build_workflow_role_arn != null ? { role_arn = var.build_workflow_role_arn } : {},
    local.has_build_workflow_keys ? {
      access_key = var.build_workflow_access_key_id
      secret_key = var.build_workflow_access_key_secret
    } : {},
  )

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
    ci    = local.ci
    setup = local.setup
  })
}
