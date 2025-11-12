output "acr_login_server" {
  description = "The FQDN of the ACR login server"
  value       = data.azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "The admin username of the ACR"
  value       = data.azurerm_container_registry.acr.admin_username
  sensitive   = true
}
output "acr_admin_password" {
  description = "The admin password of the ACR"
  value       = data.azurerm_container_registry.acr.admin_password
  sensitive   = true
}