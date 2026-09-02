resource "random_id" "bucket_suffix" {
  byte_length = 8
}

locals {
  log_bucket_provided = var.log_bucket != null && var.log_bucket != ""

  # Falls back to a bucket this module creates and grants write access to,
  # so state-bucket access logging is on out of the box (GCP-0077) without
  # forcing every caller to bring their own centralized log bucket first.
  effective_log_bucket = local.log_bucket_provided ? var.log_bucket : try(google_storage_bucket.logs[0].name, null)
}

# The GCS service agent needs write access on whatever bucket receives access
# logs — https://cloud.google.com/storage/docs/access-logs#delivery.
data "google_storage_project_service_account" "gcs_account" {
  count   = local.log_bucket_provided ? 0 : 1
  project = var.project_id
}

resource "google_storage_bucket" "logs" {
  count = local.log_bucket_provided ? 0 : 1

  name          = "${lower(var.bucket_prefix)}-logs-${random_id.bucket_suffix.hex}"
  project       = var.project_id
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  uniform_bucket_level_access = var.uniform_bucket_level_access
  public_access_prevention    = var.public_access_prevention

  versioning {
    enabled = var.versioning_enabled
  }

  labels = var.tags
}

resource "google_storage_bucket_iam_member" "logs_writer" {
  count = local.log_bucket_provided ? 0 : 1

  bucket = google_storage_bucket.logs[0].name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${data.google_storage_project_service_account.gcs_account[0].email_address}"
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

  logging {
    log_bucket = local.effective_log_bucket
  }

  labels = var.tags
}

resource "google_storage_bucket_iam_member" "allowed_members" {
  for_each = toset(var.allowed_members)

  bucket = google_storage_bucket.tf_state.name
  role   = "roles/storage.objectAdmin"
  member = each.value
}
