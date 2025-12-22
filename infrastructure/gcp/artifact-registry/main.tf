resource "google_artifact_registry_repository" "registry" {
  project       = var.project_id
  location      = var.location
  repository_id = var.repository_id
  format        = var.format
}
