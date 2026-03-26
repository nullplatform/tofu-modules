variable "bucket_id" {
  description = "ID (name) of the S3 bucket to which the policy will be applied."
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket. Used to build the resource ARNs in the secure transport statement."
  type        = string
}

variable "additional_policy_json" {
  description = <<-EOT
    Optional JSON policy document to merge with the mandatory secure transport policy.
    Must NOT contain statements with Principal \"*\" and Effect \"Allow\", as that grants
    unrestricted public access. Use specific principals (IAM roles, accounts) instead.
  EOT
  type        = string
  default     = null
}
