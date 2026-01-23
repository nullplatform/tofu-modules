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

output "action_specification_ids" {
  value = {
    for k, v in nullplatform_action_specification.from_templates : k => v.id
  }
  description = "Map of action specification names to their IDs"
}


output "link_specification_ids" {
  value = {
    for k, v in nullplatform_link_specification.from_templates : k => v.id
  }
  description = "Map of link specification names to their IDs"
}

output "nrn" {
  value       = var.nrn
  description = "The NRN of the created service specification"
}
output "git_provider" {
  value       = var.git_provider
  description = "The Git provider associated with the service specification"
}
output "git_user" {
  value       = var.git_user
  description = "The Git user associated with the service specification"
}
output "git_password" {
  value       = var.git_password
  description = "The Git password associated with the service specification"
  sensitive   = true
}
output "git_repo" {
  value       = var.git_repo
  description = "The GitHub repository URL associated with the service specification"
}
output "git_ref" {
  value       = var.git_ref
  description = "The GitHub branch associated with the service specification"
}
output "git_service_path" {
  value       = var.git_service_path
  description = "The GitHub path associated with the service specification"
}

output "service_name" {
  value       = var.service_name
  description = "The name of the scope definition"
}

output "service_description" {
  value       = var.service_description
  description = "The description of the service definition"
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
