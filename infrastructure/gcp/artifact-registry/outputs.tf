output "repository_id" {
  value = google_artifact_registry_repository.registry.repository_id
}

output "repository_url" {
  value = "${var.location}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}

output "service_account_email" {
  description = "Service Account email to use with Workload Identity"
  value       = google_service_account.artifact_sa.email
}
