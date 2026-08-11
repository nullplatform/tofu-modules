variable "project_id" {
  description = "The GCP project ID where the state bucket will be created"
  type        = string
}

variable "bucket_prefix" {
  description = "Prefix for the GCS bucket name. A random suffix will be appended since bucket names must be globally unique across all of GCP"
  type        = string
  default     = "tofu-state"
}

variable "location" {
  description = "GCS location for the bucket (e.g. a multi-region like US, or a region like us-central1)"
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "Storage class for the bucket"
  type        = string
  default     = "STANDARD"
}

variable "force_destroy" {
  description = "Allow destruction of the bucket even if it contains objects. Leave false to protect Terraform/OpenTofu state from accidental deletion"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable object versioning on the bucket, so previous state revisions can be recovered"
  type        = bool
  default     = true
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access (IAM-only, no legacy ACLs)"
  type        = bool
  default     = true
}

variable "public_access_prevention" {
  description = "Public access prevention setting for the bucket (enforced or inherited)"
  type        = string
  default     = "enforced"
}

variable "kms_key_name" {
  description = "Full resource name of an existing Cloud KMS key used to encrypt the bucket's contents. Leave null to use Google-managed encryption"
  type        = string
  default     = null
}

variable "allowed_members" {
  description = "IAM members (e.g. user:..., serviceAccount:..., group:...) granted roles/storage.objectAdmin on the bucket. When empty, access follows the project's default IAM"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "A mapping of labels to assign to the bucket"
  type        = map(string)
  default     = {}
}
