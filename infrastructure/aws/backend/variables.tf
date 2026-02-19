variable "aws_region" {
  type        = string
  description = "AWS region where the backend resources will be created"
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix for the S3 bucket name. A random suffix will be appended"
  default     = "tf-state"
}

variable "object_lock_retention_days" {
  type        = number
  description = "Number of days for S3 object lock retention in COMPLIANCE mode"
  default     = 1
}
