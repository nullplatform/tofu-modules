variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the AWS IAM OIDC provider for EKS service account authentication"
  type        = string
}

variable "agent_namespace" {
  description = "Namespace where the agent runs"
  type        = string
}