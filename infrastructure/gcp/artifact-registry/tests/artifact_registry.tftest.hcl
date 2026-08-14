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
  # apply, not plan: private_key is computed, so the output can only be compared
  # against the resource attribute once both have values.
  command = apply

  variables {
    generate_key = true
  }

  assert {
    condition     = length(google_service_account_key.artifact_sa_key) == 1
    error_message = "A service account key should be created when generate_key is true"
  }

  # Pins the output to private_key specifically. public_key is also base64 and
  # also computed on this resource, so without this a swap between them ships a
  # public key as the Docker password and only fails at runtime.
  assert {
    condition     = nonsensitive(output.service_account_key_base64) == nonsensitive(google_service_account_key.artifact_sa_key[0].private_key)
    error_message = "service_account_key_base64 must expose private_key: the _json_key_base64 Docker username expects the base64-encoded JSON key, not the public key"
  }
}

run "no_keepers_by_default_so_the_key_is_not_reissued_every_apply" {
  command = plan

  variables {
    generate_key = true
  }

  assert {
    condition     = google_service_account_key.artifact_sa_key[0].keepers == null
    error_message = "keepers must stay unset unless key_rotation_token is provided, otherwise the key churns on every apply"
  }
}

run "key_rotation_token_sets_keepers" {
  command = plan

  variables {
    generate_key       = true
    key_rotation_token = "2026-q3"
  }

  assert {
    condition     = google_service_account_key.artifact_sa_key[0].keepers["rotation"] == "2026-q3"
    error_message = "key_rotation_token should be wired to keepers so changing it forces a new key"
  }
}

run "empty_key_rotation_token_leaves_keepers_unset" {
  command = plan

  variables {
    generate_key       = true
    key_rotation_token = ""
  }

  assert {
    condition     = google_service_account_key.artifact_sa_key[0].keepers == null
    error_message = "An empty key_rotation_token must not set keepers"
  }
}
