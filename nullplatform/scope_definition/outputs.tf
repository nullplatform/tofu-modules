################################################################################
# Outputs
#
# This file exposes key values from the module so that they can be referenced
# by parent modules or other Terraform configurations.
################################################################################

# ------------------------------------------------------------------------------
# Service Specification Outputs
# ------------------------------------------------------------------------------

# ID of the service specification created in Nullplatform.
# Useful for referencing the service in other modules or APIs.
output "service_specification_id" {
  description = "ID of the service specification created in Nullplatform."
  value       = nullplatform_service_specification.from_template.id
}

# Slug (unique name) of the created service specification.
# This is typically used as an identifier for logging, metrics, or automation.
output "service_slug" {
  description = "Slug (unique name) of the service specification created in Nullplatform."
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
