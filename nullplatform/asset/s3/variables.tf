variable "nrn" {
  description = "The nullplatform resource name (NRN)"
  type        = string
}

variable "bucket_name" {
  description = "Name of the existing S3 bucket used as the asset repository, where Lambda/bundle assets are published. Maps to the platform's aws.s3_assets_bucket configuration."
  type        = string
}
