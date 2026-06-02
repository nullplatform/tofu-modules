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
  description = "ARN of the AWS IAM OIDC provider for EKS service account authentication"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster where the policy runs"
  type        = string
}
