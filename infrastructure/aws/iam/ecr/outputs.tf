output "cross_account_pull_role_arn" {
  description = "ARN of the IAM role that cross-account principals can assume to pull ECR images"
  value       = aws_iam_role.ecr_cross_account_pull.arn
}
