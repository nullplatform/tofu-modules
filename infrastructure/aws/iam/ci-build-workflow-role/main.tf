# Replaces the ci-build-workflow-user access keys: nullplatform's application
# manager assumes this role to push build assets. Asset-repository permission
# modules (ecr, s3-assets) attach their policies to it through
# build_workflow_role_name.
resource "aws_iam_role" "nullplatform_build_workflow_role" {
  name = "nullplatform-${var.cluster_name}-build-workflow-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { AWS = var.application_manager_assume_role },
      Action    = "sts:AssumeRole",
    }]
  })
}
