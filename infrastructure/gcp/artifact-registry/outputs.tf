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

output "service_account_key_base64" {
  description = "Base64-encoded JSON key for the Artifact Registry service account, for Docker clients that authenticate with username '_json_key_base64' and this value as the password. Null unless generate_key is true."
  value       = var.generate_key ? google_service_account_key.artifact_sa_key[0].private_key : null
  sensitive   = true
}
