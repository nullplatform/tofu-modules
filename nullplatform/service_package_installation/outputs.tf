output "installation_id" {
  description = "ID of the package installation."
  value       = module.installation.installation_id
}

output "installed_version" {
  description = "Version new services are born with."
  value       = module.installation.installed_version
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
