output "token_id" {
  description = "The ID of the ACR token"
  value       = azurerm_container_registry_token.this.id
}

output "username" {
  description = "The username CI logs in with (the token name)"
  value       = azurerm_container_registry_token.this.name
}

output "password" {
  description = "The token password CI logs in with"
  value       = azurerm_container_registry_token_password.this.password1[0].value
  sensitive   = true
}
