output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = var.autopilot_enabled ? module.gke_autopilot[0].name : module.gke[0].name
}

output "host" {
  description = "The API server endpoint"
  value       = var.autopilot_enabled ? module.gke_autopilot[0].endpoint : module.gke[0].endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate in base64"
  value       = var.autopilot_enabled ? module.gke_autopilot[0].ca_certificate : module.gke[0].ca_certificate
  sensitive   = true
}
