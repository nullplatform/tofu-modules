output "cluster_name" {
  value = module.gke.name
}

output "endpoint" {
  value     = module.gke.endpoint
  sensitive = true
}

output "ca_certificate" {
  value     = module.gke.ca_certificate
  sensitive = true
}
