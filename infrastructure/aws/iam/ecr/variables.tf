variable "cluster_name" {
  description = "Name of the cluster, used to namespace IAM resource names"
  type        = string
}

variable "build_workflow_group_name" {
  description = "Name of the IAM group (from the build-user module) to which the ECR manager policy is attached. The build workflow user is a member of this group."
  type        = string
}

variable "application_manager_assume_role" {
  description = "ARN of the IAM role assumed by the application manager"
  type        = string
  default     = "arn:aws:iam::283477532906:role/application_manager"
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
