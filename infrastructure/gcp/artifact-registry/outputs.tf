output "repository_id" {
  value = google_artifact_registry_repository.registry.repository_id
}

output "repository_url" {
  value = "${var.location}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}
