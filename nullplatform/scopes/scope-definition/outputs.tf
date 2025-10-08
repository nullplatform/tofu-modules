################################################################################
# Scope Definition Module Outputs
################################################################################

output "service_specification_id" {
  value       = nullplatform_service_specification.from_template.id
  description = "The ID of the created service specification"
}

output "service_specification_slug" {
  value       = nullplatform_service_specification.from_template.slug
  description = "The slug of the created service specification"
}

output "slug" {
  value       = nullplatform_service_specification.from_template.slug
  description = "The slug of the created service specification"
}

output "scope_type_id" {
  value       = nullplatform_scope_type.from_template.id
  description = "The ID of the created scope type"
}

output "action_specification_ids" {
  value = {
    for k, v in nullplatform_action_specification.from_templates : k => v.id
  }
  description = "Map of action specification names to their IDs"
}

output "nrn" {
  value       = var.nrn
  description = "The NRN of the created service specification"
}
output "git_repo_url" {
  value       = var.git_repo
  description = "The GitHub repository URL associated with the service specification"
}
output "git_ref" {
  value       = var.git_ref
  description = "The GitHub branch associated with the service specification"
}
output "git_scope_path" {
  value       = var.git_scope_path
  description = "The GitHub path associated with the service specification"
}

output "scope_name" {
  value       = var.scope_name
  description = "The name of the scope definition"
}

output "scope_description" {
  value       = var.scope_description
  description = "The name of the scope definition"
}

output "specification" {
  value       = local.service_spec_parsed
  description = "The attributes of the created service specification"
}

output "workflow_override_path" {
  value       = var.workflow_override_path
  description = "The path to the custom workflow file"
}
output "workflow_override_values" {
  value       = var.workflow_override_values 
  description = "The workflow override values"
  
}

output "scope_provider_id" {
  value       = nullplatform_service_specification.from_template.id
  description = "The ID of the scope provider associated with the scope definition"
  
}