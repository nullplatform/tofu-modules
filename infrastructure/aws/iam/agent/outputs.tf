output "nullplatform_agent_role_arn" {
  description = "ARN of the agent role"
  value       = module.nullplatform_agent_role.arn
}

output "nullplatform_agent_permissions_role_arn" {
  description = "ARN of the permissions role assumed by the agent role"
  value       = aws_iam_role.nullplatform_agent_permissions.arn
}

output "nullplatform_agent_extra_permissions_role_arns" {
  description = "Map of logical name to ARN for each additional permissions role created via permissions_roles"
  value       = { for k, r in aws_iam_role.extra_permissions : k => r.arn }
}
