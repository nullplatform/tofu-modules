output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.name
}

output "host" {
  description = "The API server endpoint"
  value       = module.gke.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate in base64"
  value       = module.gke.ca_certificate
  sensitive   = true
}
