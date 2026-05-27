output "application_role_arn" {
  description = "ARN of the IAM role used by applications to pull ECR images"
  value       = aws_iam_role.nullplatform_application_role.arn
}

output "build_workflow_access_key_id" {
  description = "Access key ID for the CI/CD build workflow IAM user"
  value       = aws_iam_access_key.nullplatform_build_workflow_user_key.id
}

output "build_workflow_access_key_secret" {
  description = "Secret access key for the CI/CD build workflow IAM user"
  value       = aws_iam_access_key.nullplatform_build_workflow_user_key.secret
  sensitive   = true
}

output "cross_account_pull_role_arn" {
  description = "ARN of the IAM role that cross-account principals can assume to pull ECR images. Empty string when enable_cross_account_pull is false."
  value       = var.enable_cross_account_pull ? aws_iam_role.ecr_cross_account_pull[0].arn : ""
}
