variable "nrn" {
  description = "The nullplatform resource name (NRN)"
  type        = string
}

variable "application_role_arn" {
  description = "ARN of the IAM role used by applications to pull ECR images"
  type        = string
}

variable "build_workflow_role_arn" {
  description = "ARN of the IAM role the CI/CD build workflow assumes to push images (maps to 'ci.role_arn'). `np asset push` assumes it with the CI runner's OIDC token (GitHub Actions) or its ambient AWS credentials, so the role's trust policy must allow that identity. Set this, a static key pair, or both while migrating: once a role is present the platform ignores the keys."
  type        = string
  default     = null

  validation {
    condition     = var.build_workflow_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.build_workflow_role_arn))
    error_message = "build_workflow_role_arn must be an IAM role ARN like arn:aws:iam::123456789012:role/ci-image-pusher"
  }
}

variable "build_workflow_access_key_id" {
  description = "Access key ID for the CI/CD build workflow IAM user (maps to 'ci.access_key'). Optional when build_workflow_role_arn is set; must be given together with build_workflow_access_key_secret."
  type        = string
  default     = null
}

variable "build_workflow_access_key_secret" {
  description = "Secret access key for the CI/CD build workflow IAM user (maps to 'ci.secret_key'). Optional when build_workflow_role_arn is set; must be given together with build_workflow_access_key_id."
  type        = string
  default     = null
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
