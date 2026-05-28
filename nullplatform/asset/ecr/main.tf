resource "nullplatform_provider_config" "ecr" {
  provider = nullplatform
  nrn      = var.nrn
  type     = "ecr"
  attributes = jsonencode({
    "ci" : {
      "region" : data.aws_region.current.region,
      "access_key" : var.build_workflow_access_key_id,
      "secret_key" : var.build_workflow_access_key_secret
    },
    "setup" : {
      "region" : data.aws_region.current.region,
      "role_arn" : var.application_role_arn,
    }
  })
  lifecycle {
    ignore_changes = [attributes]
  }
}
