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
  description = "ID of the agent notification channel, or null without create_agent_channel."
  value       = var.create_agent_channel ? module.agent_channel[0].notification_channel_id : null
}

# The outputs below carry the names scope_definition uses, so an organization
# that registered a scope with it switches to the global package by changing
# the module, not what reads it.

output "service_slug" {
  description = "Same as service_specification_slug."
  value       = local.specification_slug
}

output "provider_specification_slug" {
  description = "Same as scope_configuration_specification_slug."
  value       = var.create_scope_configuration ? nullplatform_provider_specification.scope_configuration[0].slug : null
}

output "package_id" {
  description = "ID of the installed package."
  value       = module.installation.package_id
}

output "package_default_version" {
  description = "Same as installed_version: the version new scopes are born with."
  value       = module.installation.installed_version
}
