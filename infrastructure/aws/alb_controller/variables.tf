variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where load balancers controller will be deployed"
  type        = string
}

variable "aws_load_balancer_controller_version" {
  description = "Version of the AWS Load Balancer Controller Helm chart"
  type        = string
  default     = "1.13.4"
}

variable "aws_iam_openid_connect_provider" {
  description = "AWS IAM OpenID Connect Provider for EKS cluster authentication"
  type        = string
}
