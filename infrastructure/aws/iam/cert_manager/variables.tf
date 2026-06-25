variable "hosted_zone_public_id" {
  description = "ID of the public Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted_zone_public_id or hosted_zone_private_id must be provided."
  type        = string
  default     = null

  validation {
    condition = (
      (var.hosted_zone_public_id != null && var.hosted_zone_public_id != "")
      || (var.hosted_zone_private_id != null && var.hosted_zone_private_id != "")
    )
    error_message = "At least one of hosted_zone_public_id or hosted_zone_private_id must be provided."
  }
}

variable "hosted_zone_private_id" {
  description = "ID of the private Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted_zone_public_id or hosted_zone_private_id must be provided."
  type        = string
  default     = null
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

variable "cluster_name" {
  description = "Name of the cluster where the policy runs"
  type        = string
}

variable "identity_mode" {
  description = "IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with an EKS Pod Identity association. WARNING: changing this value on an existing deployment destroys the current IAM role before creating a new one — cert-manager will lose permissions during the transition."
  type        = string
  default     = "irsa"

  validation {
    condition     = contains(["irsa", "pod_identity"], var.identity_mode)
    error_message = "identity_mode must be either 'irsa' or 'pod_identity'."
  }
}
