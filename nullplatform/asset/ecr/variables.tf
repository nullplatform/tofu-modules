variable "nrn" {
  description = "The nullplatform resource name (NRN)"
  type        = string
}

variable "application_manager_assume_role" {
  description = "ARN of the IAM role assumed by the application manager"
  type        = string
  default     = "arn:aws:iam::283477532906:role/application_manager"
}

variable "cluster_name" {
  description = "Name of the cluster where the policy runs"
  type        = string
}

variable "dimensions" {
  description = "Dimensions to segment the nullplatform provider config (e.g. by region, environment)"
  type        = map(string)
  default     = {}
}

variable "enable_cross_account_pull" {
  description = "Enable cross-account ECR pull access via a repository policy"
  type        = bool
  default     = false
}

variable "repository_policy_pull_accounts" {
  description = "AWS account IDs allowed to pull images from ECR. The account where this module is deployed is always included."
  type        = list(string)
  default     = []
}
