mock_provider "google" {}

variables {
  project_id    = "myorg-project"
  location      = "us-central1"
  repository_id = "myorg-docker"
}

run "default_format_is_docker" {
  command = plan

  assert {
    condition     = google_artifact_registry_repository.registry.format == "DOCKER"
    error_message = "Default format should be DOCKER"
  }
}

run "custom_format" {
  command = plan

  variables {
    format = "NPM"
  }

  assert {
    condition     = google_artifact_registry_repository.registry.format == "NPM"
    error_message = "Should accept custom format"
  }
}

run "repository_url_construction" {
  command = plan

  assert {
    condition     = output.repository_url == "us-central1-docker.pkg.dev/myorg-project/myorg-docker"
    error_message = "Repository URL should follow {location}-docker.pkg.dev/{project}/{repo} format"
  }
}

run "service_account_config" {
  command = plan

  assert {
    condition     = google_service_account.artifact_sa.account_id == "artifact-registry-sa"
    error_message = "SA account_id should be artifact-registry-sa"
  }
}

run "iam_writer_role" {
  command = plan

  assert {
    condition     = google_project_iam_member.artifact_sa_role.role == "roles/artifactregistry.writer"
    error_message = "SA should have artifactregistry.writer role"
  }
}

run "no_key_by_default" {
  command = plan

  assert {
    condition     = length(google_service_account_key.artifact_sa_key) == 0
    error_message = "No service account key should be created when generate_key is false"
  }

  assert {
    condition     = output.service_account_key_base64 == null
    error_message = "service_account_key_base64 output should be null when generate_key is false"
  }
}

run "key_created_when_requested" {
  command = plan

  variables {
    generate_key = true
  }

  assert {
    condition     = length(google_service_account_key.artifact_sa_key) == 1
    error_message = "A service account key should be created when generate_key is true"
  }
}
