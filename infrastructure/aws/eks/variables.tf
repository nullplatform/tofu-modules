variable "name" {
  type        = string
  description = "A name of cluster"
}

variable "ami_type" {
  type        = string
  description = "The ami type to use with node"
  default     = "AL2023_x86_64_STANDARD"
}

variable "instance_types" {
  type        = string
  description = "The instance type to use"
  default     = "t3.medium"
}

variable "kubernetes_version" {
  type        = string
  description = "The version of K8s to use"
  default     = "1.32"
}

variable "aws_vpc_vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "aws_subnets_private_ids" {
  description = "List of private subnet IDs for EKS cluster and node groups"
  type        = list(string)
}
