output "repository_id" {
  description = "The Artifact Registry repository ID"
  value       = google_artifact_registry_repository.registry.repository_id
}

output "repository_url" {
  description = "The fully-qualified Docker-compatible URL of the Artifact Registry repository"
  value       = "${var.location}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}

output "service_account_email" {
  description = "GCP Service Account email. Annotate the Kubernetes ServiceAccount bound via workload_identity_bindings with iam.gke.io/gcp-service-account=<this value> to impersonate this account from pods."
  value       = google_service_account.artifact_sa.email
}
