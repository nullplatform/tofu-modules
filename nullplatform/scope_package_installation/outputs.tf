output "installation_id" {
  description = "ID of the package installation."
  value       = module.installation.installation_id
}

output "installed_version" {
  description = "Version new scopes are born with."
  value       = module.installation.installed_version
}

output "missing_optional_requirements" {
  description = "Optional providers the package can use that were not configured at nrn or above it when it was installed."
  value       = module.installation.missing_optional_requirements
}

output "service_specification_id" {
  description = "ID of the package's scope specification, the one the scope type points at."
  value       = local.specification_id
}

output "service_specification_slug" {
  description = "Slug of the package's scope specification."
  value       = local.specification_slug
}

output "scope_type_id" {
  description = "ID of the scope type created in the organization."
  value       = nullplatform_scope_type.this.id
}

output "scope_configuration_specification_id" {
  description = "ID of the scope-configuration provider specification, or null without create_scope_configuration."
  value       = var.create_scope_configuration ? nullplatform_provider_specification.scope_configuration[0].id : null
}

output "scope_configuration_specification_slug" {
  description = "Slug of the scope-configuration provider specification: the `type` of the provider config that holds the scope's settings. Null without create_scope_configuration."
  value       = var.create_scope_configuration ? nullplatform_provider_specification.scope_configuration[0].slug : null
}

output "notification_channel_id" {
  description = "ID of the agent notification channel."
  value       = module.agent_channel.notification_channel_id
}
