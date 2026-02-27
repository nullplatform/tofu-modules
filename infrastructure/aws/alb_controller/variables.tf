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

variable "service_account_name" {
  description = "Name of the Kubernetes service account for the AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}
