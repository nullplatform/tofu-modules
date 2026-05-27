variable "cluster_name" {
  description = "Name of the cluster, used to namespace IAM resource names"
  type        = string
}

variable "pull_account_ids" {
  description = "AWS account IDs allowed to assume the cross-account ECR pull role"
  type        = list(string)
}
