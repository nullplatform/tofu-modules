variable "nrn" {
  description = "The nullplatform resource name (NRN)"
  type        = string
}

variable "dimensions" {
  description = "Dimensions to segment the nullplatform provider config (e.g. by region, environment)"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Name of the existing S3 bucket used as the asset repository, where Lambda/bundle assets are published. Maps to the platform's aws.s3_assets_bucket configuration."
  type        = string
}
