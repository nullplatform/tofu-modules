resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "google_storage_bucket" "tf_state" {
  # GCS rejects uppercase bucket names, so the caller-supplied prefix is lowercased.
  name          = "${lower(var.bucket_prefix)}-${random_id.bucket_suffix.hex}"
  project       = var.project_id
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  uniform_bucket_level_access = var.uniform_bucket_level_access
  public_access_prevention    = var.public_access_prevention

  versioning {
    enabled = var.versioning_enabled
  }

  # Empty string as well as null: an empty value reaches here whenever the key is
  # wired from another module's output or a TF_VAR, and would emit an empty key.
  dynamic "encryption" {
    for_each = var.kms_key_name != null && var.kms_key_name != "" ? [var.kms_key_name] : []
    content {
      default_kms_key_name = encryption.value
    }
  }

  dynamic "logging" {
    for_each = var.log_bucket != null && var.log_bucket != "" ? [var.log_bucket] : []
    content {
      log_bucket = logging.value
    }
  }

  labels = var.tags
}

resource "google_storage_bucket_iam_member" "allowed_members" {
  for_each = toset(var.allowed_members)

  bucket = google_storage_bucket.tf_state.name
  role   = "roles/storage.objectAdmin"
  member = each.value
}
