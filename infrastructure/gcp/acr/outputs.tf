output "acr_id" {
  description = "The ID of the container registry"
  value       = google_artifact_registry_repository.registry.id
}

output "acr_login_server" {
  description = "The URL of the container registry"
  value       = "${var.location}-docker.pkg.dev/${var.project_id}/${var.containerregistry_name}"
}

output "service_account_email" {
  description = "GCP Service Account email. Annotate the Kubernetes ServiceAccount bound via workload_identity_bindings with iam.gke.io/gcp-service-account=<this value> to impersonate this account from pods."
  value       = google_service_account.artifact_sa.email
}
