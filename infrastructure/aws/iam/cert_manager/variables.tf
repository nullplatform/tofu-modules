variable "hosted_zone_public_id" {
  description = "ID of the public Route53 hosted zone for DNS validation"
  type        = string
}
variable "hosted_zone_private_id" {
  description = "ID of the private Route53 hosted zone for DNS validation"
  type        = string
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the AWS IAM OIDC provider for EKS service account authentication"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster where the policy runs"
  type        = string
}
