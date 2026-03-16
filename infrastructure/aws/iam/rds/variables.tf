variable "name" {
  description = "Unique identifier for policy naming. Must be unique per AWS account (IAM policy names are account-global). Example: \"prod-us-east-1\"."
  type        = string
}

variable "role_name" {
  description = "IAM role name to attach the RDS policies to. If set, Terraform manages the attachments and will detach them automatically on destroy."
  type        = string
  default     = null
}
