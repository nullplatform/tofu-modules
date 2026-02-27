variable "aws_region" {
  description = "AWS region where the backend resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name. A random suffix will be appended"
  type        = string
  default     = "tf-state"
}

variable "force_destroy" {
  description = "Allow destruction of the S3 bucket even if it contains objects"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm for the S3 bucket (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS key ARN for S3 bucket encryption. Required when sse_algorithm is aws:kms"
  type        = string
  default     = null
}
