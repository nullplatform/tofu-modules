output "acr_login_server" {
  description = "FQDN del login server del ACR."
  value       = data.azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "Usuario admin del ACR."
  value       = data.azurerm_container_registry.acr.admin_username
  sensitive   = true
}
output "acr_admin_password" {
  description = "Password admin del ACR."
  value       = data.azurerm_container_registry.acr.admin_password
  sensitive   = true
}