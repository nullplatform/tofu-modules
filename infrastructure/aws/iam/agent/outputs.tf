output "nullplatform_agent_role_arn" {
  description = "ARN of the agent role"
  value       = module.nullplatform_agent_role.arn
}

output "nullplatform_agent_permissions_role_arn" {
  description = "ARN of the permissions role assumed by the agent role"
  value       = aws_iam_role.nullplatform_agent_permissions.arn
}
