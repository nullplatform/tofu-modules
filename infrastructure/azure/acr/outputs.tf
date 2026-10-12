# Read from the registry resource itself rather than a data source that
# depends on the module: such a data source is deferred to apply whenever the
# registry has any change (e.g. admin_enabled), turning acr_id unknown and
# forcing every consumer keyed on it — the AKS AcrPull role assignment, the
# push token — to be replaced.

output "acr_id" {
  description = "The ID of the Azure Container Registry"
  value       = module.containerregistry.resource_id
}

output "acr_login_server" {
  description = "The FQDN of the ACR login server"
  value       = module.containerregistry.resource.login_server
}

output "acr_admin_username" {
  description = "The admin username of the ACR. Null when admin_enabled is false."
  value       = var.admin_enabled ? module.containerregistry.resource.admin_username : null
  sensitive   = true
}
output "acr_admin_password" {
  description = "The admin password of the ACR. Null when admin_enabled is false."
  value       = var.admin_enabled ? module.containerregistry.resource.admin_password : null
  sensitive   = true
}
