resource "google_artifact_registry_repository" "registry" {
  project       = var.project_id
  location      = var.location
  repository_id = var.repository_id
  format        = var.format
}

resource "google_service_account" "artifact_sa" {
  account_id   = "artifact-registry-sa"
  display_name = "Service Account para Artifact Registry"
  description  = "Used to push/pull Docker images"
}

resource "google_project_iam_member" "artifact_sa_role" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.artifact_sa.email}"
}

resource "google_service_account_iam_member" "workload_identity" {
  for_each = {
    for wi in var.workload_identity_bindings : "${wi.namespace}-${wi.ksa_name}" => wi
  }

  service_account_id = google_service_account.artifact_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value.namespace}/${each.value.ksa_name}]"
}
