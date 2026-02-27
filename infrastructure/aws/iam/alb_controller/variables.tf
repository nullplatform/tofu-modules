variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the AWS IAM OIDC provider for EKS service account authentication"
  type        = string
}
