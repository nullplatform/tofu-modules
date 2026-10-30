output "installation_id" {
  description = "ID of the package installation."
  value       = module.installation.installation_id
}

output "installed_version" {
  description = "Version new services are born with."
  value       = module.installation.installed_version
}

output "missing_optional_requirements" {
  description = "Optional providers the package can use that were not configured at nrn or above it when it was installed."
  value       = module.installation.missing_optional_requirements
}

output "service_specification_id" {
  description = "ID of the package's service specification."
  value       = module.installation.service_specification_id
}

output "service_specification_slug" {
  description = "Slug of the package's service specification."
  value       = module.installation.service_specification_slug
}

output "notification_channel_id" {
  description = "ID of the agent notification channel."
  value       = module.agent_channel.id
}
