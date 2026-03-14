output "rds_policy_arn" {
  description = "ARN of the RDS management policy"
  value       = aws_iam_policy.nullplatform_rds_policy.arn
}

output "rds_sg_policy_arn" {
  description = "ARN of the EC2 security group policy"
  value       = aws_iam_policy.nullplatform_rds_sg_policy.arn
}

output "rds_secretsmanager_policy_arn" {
  description = "ARN of the Secrets Manager policy"
  value       = aws_iam_policy.nullplatform_rds_secretsmanager_policy.arn
}
