variable "nrn" {
  description = "The nullplatform resource name (NRN)"
  type        = string
}

variable "application_role_arn" {
  description = "ARN of the IAM role used by applications to pull ECR images"
  type        = string
}

variable "build_workflow_access_key_id" {
  description = "Access key ID for the CI/CD build workflow IAM user"
  type        = string
}

variable "build_workflow_access_key_secret" {
  description = "Secret access key for the CI/CD build workflow IAM user"
  type        = string
  sensitive   = true
}

variable "repository_policy" {
  description = "ECR repository policy JSON applied to every new repository Nullplatform creates (maps to 'setup.policy'). Leave empty to omit."
  type        = string
  default     = ""
}

variable "naming_rule" {
  description = "jq expression for ECR repository naming convention. Defaults to the Nullplatform platform default."
  type        = string
  default     = "\"\\(.namespace.slug)/\\(.application.slug)\""
}
