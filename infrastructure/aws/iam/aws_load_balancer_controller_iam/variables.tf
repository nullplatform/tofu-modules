variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the AWS IAM OIDC provider for EKS service account authentication"
  type        = string
}

variable "service_account_namespace" {
  description = "Kubernetes namespace where the AWS Load Balancer Controller service account will be created"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account for the AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}
