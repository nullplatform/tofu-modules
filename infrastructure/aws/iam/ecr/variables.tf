variable "cluster_name" {
  description = "Name of the cluster, used to namespace IAM resource names"
  type        = string
}

variable "enable_cross_account_pull" {
  description = "Enable cross-account ECR pull access by creating an IAM role that external accounts can assume"
  type        = bool
  default     = false
}

variable "pull_account_ids" {
  description = "AWS account IDs allowed to assume the cross-account ECR pull role. Required when enable_cross_account_pull is true."
  type        = list(string)
  default     = []
}
