variable "cluster_name" {
  description = "Name of the cluster the role belongs to. Used to build the role and policy names."
  type        = string
}

variable "identity_mode" {
  description = "IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with an EKS Pod Identity association. Note: switching modes on an existing deployment replaces the IAM role; the logs controller loses permissions during the transition until apply completes."
  type        = string
  default     = "irsa"

  validation {
    condition     = contains(["irsa", "pod_identity"], var.identity_mode)
    error_message = "identity_mode must be either 'irsa' or 'pod_identity'."
  }
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the AWS IAM OIDC provider. Required when identity_mode is 'irsa'; ignored when identity_mode is 'pod_identity'."
  type        = string
  default     = null

  validation {
    condition     = var.identity_mode != "irsa" || (var.aws_iam_openid_connect_provider_arn != null && var.aws_iam_openid_connect_provider_arn != "")
    error_message = "aws_iam_openid_connect_provider_arn is required when identity_mode is 'irsa'."
  }
}

variable "service_account_namespace" {
  description = "Namespace of the logs controller ServiceAccount. Must match the base chart's namespaces.nullplatformTools."
  type        = string
  default     = "nullplatform-tools"
}

variable "service_account_name" {
  description = "Name of the logs controller ServiceAccount that assumes this role."
  type        = string
  default     = "nullplatform-pod-metadata-reader-sa"
}

variable "log_group_arn_patterns" {
  description = "Resource ARN patterns the logs controller may write log groups/streams to. Defaults to any CloudWatch log group in the account/region; tighten to a prefix (e.g. arn:aws:logs:*:*:log-group:/nullplatform/*) to restrict."
  type        = list(string)
  default = [
    "arn:aws:logs:*:*:log-group:*",
    "arn:aws:logs:*:*:log-group:*:*"
  ]
}
