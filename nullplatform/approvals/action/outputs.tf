output "id" {
  description = "Id of the approval action."
  value       = nullplatform_approval_action.this.id
}

output "entity" {
  description = "Entity of the action, derived from it (deployment for deployment:create)."
  value       = local.entity
}

output "action" {
  description = "The action that needs approval."
  value       = var.action
}

output "dimensions" {
  description = "Dimensions the action applies to."
  value       = var.dimensions
}
