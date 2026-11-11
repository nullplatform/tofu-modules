variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where load balancers controller will be deployed"
  type        = string
}

variable "aws_load_balancer_controller_version" {
  # example: 3.6.2
  description = "No default: every install pins this deliberately — see VERSIONS.md. Version of the AWS Load Balancer Controller Helm chart. Chart 3.x ships app v3, which needs its CRDs applied by hand (Helm does not upgrade them): pin what the cluster already runs and upgrade deliberately"
  type        = string

  validation {
    condition     = var.aws_load_balancer_controller_version != "" && !contains(["latest", "main", "master"], lower(var.aws_load_balancer_controller_version))
    error_message = "aws_load_balancer_controller_version must be a non-empty fixed version, not empty and not a moving reference."
  }
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account for the AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}
