output "cross_account_pull_role_arn" {
  description = "ARN of the IAM role that cross-account principals can assume to pull ECR images. Empty string when enable_cross_account_pull is false."
  value       = var.enable_cross_account_pull ? aws_iam_role.ecr_cross_account_pull[0].arn : ""
}
