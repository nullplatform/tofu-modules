mock_provider "google" {}

variables {
  project_id = "myorg-project"
}

run "bucket_uses_default_prefix" {
  # random_id.bucket_suffix is unknown until apply, so the bucket name can't
  # be asserted on during plan.
  command = apply

  assert {
    condition     = can(regex("^tofu-state-[0-9a-f]+$", google_storage_bucket.tf_state.name))
    error_message = "Bucket name should be bucket_prefix followed by a random hex suffix"
  }
}

run "custom_bucket_prefix" {
  command = apply

  variables {
    bucket_prefix = "myorg-tfstate"
  }

  assert {
    condition     = can(regex("^myorg-tfstate-[0-9a-f]+$", google_storage_bucket.tf_state.name))
    error_message = "Bucket name should use the custom prefix"
  }
}

run "versioning_enabled_by_default" {
  command = plan

  assert {
    condition     = google_storage_bucket.tf_state.versioning[0].enabled == true
    error_message = "Versioning should be enabled by default"
  }
}

run "force_destroy_disabled_by_default" {
  command = plan

  assert {
    condition     = google_storage_bucket.tf_state.force_destroy == false
    error_message = "force_destroy should default to false to protect state"
  }
}

run "public_access_prevention_enforced_by_default" {
  command = plan

  assert {
    condition     = google_storage_bucket.tf_state.public_access_prevention == "enforced"
    error_message = "Public access prevention should be enforced by default"
  }
}

run "no_encryption_block_by_default" {
  command = plan

  assert {
    condition     = length(google_storage_bucket.tf_state.encryption) == 0
    error_message = "No customer-managed encryption should be configured when kms_key_name is not set"
  }
}

run "encryption_block_when_kms_key_provided" {
  command = plan

  variables {
    kms_key_name = "projects/myorg-project/locations/us-central1/keyRings/myorg-ring/cryptoKeys/myorg-key"
  }

  assert {
    condition     = google_storage_bucket.tf_state.encryption[0].default_kms_key_name == "projects/myorg-project/locations/us-central1/keyRings/myorg-ring/cryptoKeys/myorg-key"
    error_message = "Encryption block should use the provided KMS key"
  }
}

run "no_iam_bindings_by_default" {
  command = plan

  assert {
    condition     = length(google_storage_bucket_iam_member.allowed_members) == 0
    error_message = "No IAM bindings should be created when allowed_members is empty"
  }
}

run "iam_binding_for_allowed_member" {
  command = plan

  variables {
    allowed_members = ["user:admin@example.com"]
  }

  assert {
    condition     = google_storage_bucket_iam_member.allowed_members["user:admin@example.com"].role == "roles/storage.objectAdmin"
    error_message = "Allowed member should be granted storage.objectAdmin role"
  }
}

run "labels_applied" {
  command = plan

  variables {
    labels = {
      env = "test"
    }
  }

  assert {
    condition     = google_storage_bucket.tf_state.labels["env"] == "test"
    error_message = "Labels should be applied from the labels variable"
  }
}
