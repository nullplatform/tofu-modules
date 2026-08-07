################################################################################
# Outputs
#
# This file exposes key values from the module so that they can be referenced
# by parent modules or other Terraform configurations.
################################################################################

# ------------------------------------------------------------------------------
# Service Specification Outputs
# ------------------------------------------------------------------------------

# ID of the service specification created in nullplatform.
# Useful for referencing the service in other modules or APIs.
output "service_specification_id" {
  description = "ID of the service specification created in nullplatform."
  value       = nullplatform_service_specification.from_template.id
}

# Slug (unique name) of the created service specification.
# This is typically used as an identifier for logging, metrics, or automation.
output "service_slug" {
  description = "Slug (unique name) of the service specification created in nullplatform."
  value       = nullplatform_service_specification.from_template.slug
}

# ------------------------------------------------------------------------------
# Scope Type Outputs
# ------------------------------------------------------------------------------

# ID of the scope type created from the template.
# Scope types define the context or environment under which services operate.
output "scope_type_id" {
  description = "ID of the scope type created from the template."
  value       = nullplatform_scope_type.from_template.id
}

# ------------------------------------------------------------------------------
# Action Specification Outputs
# ------------------------------------------------------------------------------

# Map of all action specifications created from templates.
# Each key corresponds to an action name, and each value is its unique ID.
output "actions_created" {
  description = "Map of all action specifications created from templates."
  value       = { for k, v in nullplatform_action_specification.from_templates : k => v.id }
}

# ------------------------------------------------------------------------------
# Repository Ref
output "scope_configuration" {
  value       = local.scope_configuration
  description = "Parsed scope configuration from scope-configuration.json.tpl, or null if not fetched"
}

output "provider_specification_id" {
  value       = var.create_scope_configuration ? nullplatform_provider_specification.from_scope_configuration[0].id : null
  description = "The ID of the created provider specification, or null if scope configuration was not fetched"
}

output "provider_specification_slug" {
  value       = var.create_scope_configuration ? nullplatform_provider_specification.from_scope_configuration[0].slug : null
  description = "The slug of the created provider specification, or null if scope configuration was not fetched"
}
# ------------------------------------------------------------------------------
# Package Outputs (null unless var.package is set)
# ------------------------------------------------------------------------------

output "package_id" {
  description = "ID of the package registered from this scope definition, or null when packaging is disabled."
  value       = var.package != null ? nullplatform_package.this[0].id : null
}

output "package_published_revision_id" {
  description = "Revision UUID published for the configured package version, or null."
  value       = var.package != null ? nullplatform_package.this[0].published_revision_id : null
}

output "package_default_version" {
  description = "The package's default version after apply, or null."
  value       = var.package != null ? nullplatform_package.this[0].default_version : null
}

output "package_artifacts" {
  description = "Artifacts registered by this module: name => { resource_id, resource_revision_id }."
  value = {
    for k, v in nullplatform_artifact.package : k => {
      resource_id          = v.artifact_id
      resource_revision_id = v.id
    }
  }
}
