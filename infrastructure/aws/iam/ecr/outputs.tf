output "application_role_arn" {
  description = "ARN of the IAM role used by applications to pull ECR images"
  value       = aws_iam_role.nullplatform_application_role.arn
}

output "ecr_repository_policy" {
  description = "ECR repository policy JSON granting pull access to the configured cross-account IDs. Empty string when enable_cross_account_pull is false."
  value = var.enable_cross_account_pull ? jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "CrossAccountPull"
      Effect = "Allow"
      Principal = {
        AWS = [for id in var.pull_account_ids : "arn:aws:iam::${id}:root"]
      }
      Action = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    }]
  }) : ""
}
