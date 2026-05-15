output "cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.aks_name
}

output "host" {
  description = "The API server endpoint"
  value       = module.aks.host
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate in base64"
  value       = module.aks.cluster_ca_certificate
  sensitive   = true
}

output "client_certificate" {
  description = "The client certificate for authentication"
  value       = module.aks.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "The client key for authentication"
  value       = module.aks.client_key
  sensitive   = true
}

output "admin_client_certificate" {
  description = "The admin client certificate for authentication"
  value       = try(module.aks.admin_client_certificate, null)
  sensitive   = true
}

output "admin_client_key" {
  description = "The admin client key for authentication"
  value       = try(module.aks.admin_client_key, null)
  sensitive   = true
}

output "admin_cluster_ca_certificate" {
  description = "The admin cluster CA certificate in base64"
  value       = try(module.aks.admin_cluster_ca_certificate, null)
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "The URL of the cluster's OIDC issuer"
  value       = module.aks.oidc_issuer_url
}

output "node_resource_group" {
  description = "The name of the auto-generated resource group for AKS node resources"
  value       = module.aks.node_resource_group
}
