output "acr_id" {
  description = "The ID of the container registry"
  value       = google_artifact_registry_repository.registry.id
}

output "acr_login_server" {
  description = "The URL of the container registry"
  value       = "${var.location}-docker.pkg.dev/${var.project_id}/${var.containerregistry_name}"
}

output "service_account_key_json" {
  description = "The Service Account key for container registry access"
  value       = google_service_account_key.artifact_sa_key.private_key
  sensitive   = true
}
