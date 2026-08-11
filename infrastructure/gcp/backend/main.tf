resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "google_storage_bucket" "tf_state" {
  name          = "${var.bucket_prefix}-${lower(random_id.bucket_suffix.hex)}"
  project       = var.project_id
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  uniform_bucket_level_access = var.uniform_bucket_level_access
  public_access_prevention    = var.public_access_prevention

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "encryption" {
    for_each = var.kms_key_name != null ? [var.kms_key_name] : []
    content {
      default_kms_key_name = encryption.value
    }
  }

  labels = var.labels
}

resource "google_storage_bucket_iam_member" "allowed_members" {
  for_each = toset(var.allowed_members)

  bucket = google_storage_bucket.tf_state.name
  role   = "roles/storage.objectAdmin"
  member = each.value
}
