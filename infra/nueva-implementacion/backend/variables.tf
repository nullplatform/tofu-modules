variable "aws_region" {
  type        = string
  description = "AWS region where the backend resources will be created"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile to use for authentication"
  default     = null
}
