variable "project_id" {
  description = "The GCP project ID where the state bucket will be created"
  type        = string
}

variable "bucket_prefix" {
  description = "Prefix for the GCS bucket name. A random suffix will be appended since bucket names must be globally unique across all of GCP. Lowercased automatically, since GCS bucket names cannot contain uppercase characters"
  type        = string
  default     = "tofu-state"
  nullable    = false

  # The random suffix adds 17 characters ("-" plus 16 hex), and a GCS bucket
  # name is capped at 63.
  validation {
    condition     = length(var.bucket_prefix) >= 1 && length(var.bucket_prefix) <= 46
    error_message = "bucket_prefix must be 1-46 characters: the module appends a 17-character random suffix and GCS caps bucket names at 63."
  }

  # Dots are legal in GCS names but turn the bucket into a domain-named bucket,
  # which requires verified domain ownership — excluded rather than silently failing at apply.
  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9_-]*[a-z0-9])?$", lower(var.bucket_prefix)))
    error_message = "bucket_prefix may contain only letters, numbers, hyphens and underscores, and must start and end with a letter or number."
  }

  validation {
    condition     = !can(regex("^goog", lower(var.bucket_prefix))) && !can(regex("google", lower(var.bucket_prefix)))
    error_message = "bucket_prefix cannot start with 'goog' or contain 'google': GCS reserves those names."
  }
}

variable "location" {
  description = "GCS location for the bucket (e.g. a multi-region like US, or a region like us-central1)"
  type        = string
  default     = "US"
  nullable    = false
}

variable "storage_class" {
  description = "Storage class for the bucket"
  type        = string
  default     = "STANDARD"
  nullable    = false

  validation {
    condition = contains([
      "STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE",
      "MULTI_REGIONAL", "REGIONAL", "DURABLE_REDUCED_AVAILABILITY",
    ], var.storage_class)
    error_message = "storage_class must be one of STANDARD, NEARLINE, COLDLINE, ARCHIVE, or the legacy MULTI_REGIONAL, REGIONAL, DURABLE_REDUCED_AVAILABILITY."
  }
}

variable "force_destroy" {
  description = "Allow destruction of the bucket even if it contains objects. Leave false to protect Terraform/OpenTofu state from accidental deletion"
  type        = bool
  default     = false
  nullable    = false
}

variable "versioning_enabled" {
  description = "Enable object versioning on the bucket, so previous state revisions can be recovered. Note that prior revisions persist as non-current object versions until a lifecycle rule removes them, so any secret that ever passed through state remains readable in the bucket"
  type        = bool
  default     = true
  nullable    = false
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access (IAM-only, no legacy ACLs)"
  type        = bool
  default     = true
  nullable    = false
}

variable "public_access_prevention" {
  description = "Public access prevention setting for the bucket (enforced or inherited)"
  type        = string
  default     = "enforced"
  nullable    = false

  validation {
    condition     = contains(["enforced", "inherited"], var.public_access_prevention)
    error_message = "public_access_prevention must be either 'enforced' or 'inherited'."
  }
}

variable "kms_key_name" {
  description = "Full resource name of an existing Cloud KMS key used to encrypt the bucket's contents. Leave null or empty to use Google-managed encryption. When set, the project's GCS service agent must already hold roles/cloudkms.cryptoKeyEncrypterDecrypter on the key — this module does not grant it"
  type        = string
  default     = null
}

variable "log_bucket" {
  description = "Name of an existing GCS bucket to receive this bucket's access logs. Leave null or empty to disable access logging. Recommended for a state bucket, so reads of state objects leave an audit trail"
  type        = string
  default     = null
}

variable "allowed_members" {
  description = "IAM members (e.g. user:..., serviceAccount:..., group:...) additionally granted roles/storage.objectAdmin on the bucket. These bindings are additive: they grant access on top of whatever the project's IAM already allows, and do not restrict or revoke inherited access"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "tags" {
  description = "A mapping of labels to assign to the bucket"
  type        = map(string)
  default     = {}
  nullable    = false
}
