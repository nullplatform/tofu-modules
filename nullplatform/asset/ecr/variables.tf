variable "nrn" {
  description = "The nullplatform resource name (NRN)"
  type        = string
}

variable "dimensions" {
  description = "Dimensions to segment the nullplatform provider config (e.g. by region, environment)"
  type        = map(string)
  default     = {}
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

variable "cross_account_pull_role_arn" {
  description = "ARN of the IAM role for cross-account ECR pull access (maps to 'read.role_arn' in provider config). Leave empty to omit the read section."
  type        = string
  default     = ""
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
