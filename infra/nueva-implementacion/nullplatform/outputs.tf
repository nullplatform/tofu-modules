output "scope_specification_id" {
  description = "Scope specification ID (from service_specification)"
  value       = module.scope_definition.service_specification_id
}

output "scope_specification_slug" {
  description = "Scope specification slug (from service_slug)"
  value       = module.scope_definition.service_slug
}
