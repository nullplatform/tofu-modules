output "nullplatform_cloudwatch_role_arn" {
  description = "ARN of the CloudWatch logs controller role"
  value       = var.identity_mode == "irsa" ? one(module.nullplatform_cloudwatch_role[*].arn) : one(aws_iam_role.pod_identity[*].arn)
}
