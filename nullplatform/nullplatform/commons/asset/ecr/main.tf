resource "nullplatform_provider_config" "ecr" {
  provider   = nullplatform
  nrn        = var.nrn
  type       = "ecr"
  dimensions = {}
  attributes = jsonencode({
    "ci" : {
      "region" : data.aws_region.current.region,
      "access_key" : aws_iam_access_key.nullplatform_build_workflow_user_key.id
      "secret_key" : aws_iam_access_key.nullplatform_build_workflow_user_key.secret
    },
    "setup" : {
      "region" : data.aws_region.current.region,
      "role_arn" : aws_iam_role.nullplatform_application_role.arn
    }
  })
  lifecycle {
    ignore_changes = [attributes]
  }
}