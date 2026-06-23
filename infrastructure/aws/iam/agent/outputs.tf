output "nullplatform_agent_role_arn" {
  description = "ARN of the agent role"
  value       = module.nullplatform_agent_role.arn
}

output "nullplatform_agent_permissions_role_arn" {
  description = "Conventional ARN of the permissions role the agent role is allowed to assume. The role itself is created externally (k8s scope tofu module), not by this module."
  value       = local.permissions_role_arn
}

output "nullplatform_agent_extra_permissions_role_arns" {
  description = "Map of logical name to ARN for each additional permissions role created via permissions_roles"
  value       = { for k, r in aws_iam_role.extra_permissions : k => r.arn }
}
