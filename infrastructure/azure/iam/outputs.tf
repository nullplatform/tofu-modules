output "client_id" {
  description = "The client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.this.client_id
}

output "principal_id" {
  description = "The principal ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "id" {
  description = "The resource ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.this.id
}
