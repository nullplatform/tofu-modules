mock_provider "google" {}

variables {
  project_id = "myorg-project"
}

run "bucket_uses_default_prefix" {
  # random_id.bucket_suffix is unknown until apply, so the bucket name can't
  # be asserted on during plan.
  command = apply

  assert {
    condition     = can(regex("^tofu-state-[0-9a-f]{16}$", google_storage_bucket.tf_state.name))
    error_message = "Bucket name should be bucket_prefix followed by a 16-character random hex suffix"
  }
}

run "custom_bucket_prefix" {
  command = apply

  variables {
    bucket_prefix = "myorg-tfstate"
  }

  assert {
    condition     = can(regex("^myorg-tfstate-[0-9a-f]{16}$", google_storage_bucket.tf_state.name))
    error_message = "Bucket name should use the custom prefix"
  }
}

run "uppercase_bucket_prefix_is_lowercased" {
  command = apply

  variables {
    bucket_prefix = "MyOrg-TFState"
  }

  assert {
    condition     = google_storage_bucket.tf_state.name == lower(google_storage_bucket.tf_state.name)
    error_message = "Bucket name must be entirely lowercase: GCS rejects uppercase bucket names"
  }

  assert {
    condition     = can(regex("^myorg-tfstate-[0-9a-f]{16}$", google_storage_bucket.tf_state.name))
    error_message = "An uppercase bucket_prefix should be lowercased, not passed through"
  }
}

run "bucket_prefix_over_46_chars_is_rejected" {
  command = plan

  variables {
    # 47 characters: with the 17-character suffix this would exceed the GCS limit of 63.
    bucket_prefix = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }

  expect_failures = [var.bucket_prefix]
}

run "bucket_prefix_with_illegal_characters_is_rejected" {
  command = plan

  variables {
    bucket_prefix = "myorg tfstate!"
  }

  expect_failures = [var.bucket_prefix]
}

run "bucket_prefix_with_trailing_hyphen_is_rejected" {
  command = plan

  variables {
    bucket_prefix = "myorg-tfstate-"
  }

  expect_failures = [var.bucket_prefix]
}

run "bucket_prefix_using_reserved_google_name_is_rejected" {
  command = plan

  variables {
    bucket_prefix = "google-tfstate"
  }

  expect_failures = [var.bucket_prefix]
}

run "location_and_storage_class_defaults" {
  command = plan

  assert {
    condition     = google_storage_bucket.tf_state.location == "US"
    error_message = "Location should default to the US multi-region"
  }

  assert {
    condition     = google_storage_bucket.tf_state.storage_class == "STANDARD"
    error_message = "Storage class should default to STANDARD"
  }
}

run "invalid_storage_class_is_rejected" {
  command = plan

  variables {
    storage_class = "SUPERCOLD"
  }

  expect_failures = [var.storage_class]
}

run "uniform_bucket_level_access_enabled_by_default" {
  command = plan

  assert {
    condition     = google_storage_bucket.tf_state.uniform_bucket_level_access == true
    error_message = "Uniform bucket-level access should be enabled by default: legacy ACLs must not be reachable on a bucket holding state"
  }
}

run "uniform_bucket_level_access_can_be_disabled" {
  command = plan

  variables {
    uniform_bucket_level_access = false
  }

  assert {
    condition     = google_storage_bucket.tf_state.uniform_bucket_level_access == false
    error_message = "uniform_bucket_level_access should be settable to false"
  }
}

run "versioning_enabled_by_default" {
  command = plan

  assert {
    condition     = google_storage_bucket.tf_state.versioning[0].enabled == true
    error_message = "Versioning should be enabled by default"
  }
}

run "versioning_can_be_disabled" {
  command = plan

  variables {
    versioning_enabled = false
  }

  assert {
    condition     = google_storage_bucket.tf_state.versioning[0].enabled == false
    error_message = "versioning_enabled should be settable to false"
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

run "public_access_prevention_accepts_inherited" {
  command = plan

  variables {
    public_access_prevention = "inherited"
  }

  assert {
    condition     = google_storage_bucket.tf_state.public_access_prevention == "inherited"
    error_message = "public_access_prevention should accept the documented 'inherited' value"
  }
}

run "invalid_public_access_prevention_is_rejected" {
  command = plan

  variables {
    # One character off the legal value; without validation this passes plan and
    # only fails at apply, leaving the operator believing PAP is set.
    public_access_prevention = "enforce"
  }

  expect_failures = [var.public_access_prevention]
}

run "no_encryption_block_by_default" {
  command = plan

  assert {
    condition     = length(google_storage_bucket.tf_state.encryption) == 0
    error_message = "No customer-managed encryption should be configured when kms_key_name is not set"
  }
}

run "empty_kms_key_name_emits_no_encryption_block" {
  command = plan

  variables {
    # An empty string reaches the module whenever the key is wired from another
    # module's output or a TF_VAR; it must fall back to Google-managed encryption.
    kms_key_name = ""
  }

  assert {
    condition     = length(google_storage_bucket.tf_state.encryption) == 0
    error_message = "An empty kms_key_name must not emit an encryption block with an empty key"
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

run "no_logging_block_by_default" {
  command = plan

  assert {
    condition     = length(google_storage_bucket.tf_state.logging) == 0
    error_message = "Access logging should not be configured when log_bucket is not set"
  }
}

run "empty_log_bucket_emits_no_logging_block" {
  command = plan

  variables {
    log_bucket = ""
  }

  assert {
    condition     = length(google_storage_bucket.tf_state.logging) == 0
    error_message = "An empty log_bucket must not emit a logging block with an empty target"
  }
}

run "logging_block_when_log_bucket_provided" {
  command = plan

  variables {
    log_bucket = "myorg-access-logs"
  }

  assert {
    condition     = google_storage_bucket.tf_state.logging[0].log_bucket == "myorg-access-logs"
    error_message = "Logging block should target the provided log bucket"
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

  assert {
    condition     = length(google_storage_bucket_iam_member.allowed_members) == 1
    error_message = "One binding should be created per allowed member"
  }
}

run "tags_applied" {
  command = plan

  variables {
    tags = {
      env = "test"
    }
  }

  assert {
    condition     = google_storage_bucket.tf_state.labels["env"] == "test"
    error_message = "Labels should be applied from the tags variable"
  }
}
