output "host" {
  value = module.aks.host
}

output "client_certificate" {
  value     = module.aks.client_certificate
  sensitive = true
}

output "client_key" {
  value     = module.aks.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = module.aks.cluster_ca_certificate
  sensitive = true
}

output "admin_client_certificate" {
  value     = try(module.aks.admin_client_certificate, null)
  sensitive = true
}

output "admin_client_key" {
  value     = try(module.aks.admin_client_key, null)
  sensitive = true
}

output "admin_cluster_ca_certificate" {
  value     = try(module.aks.admin_cluster_ca_certificate, null)
  sensitive = true
}
