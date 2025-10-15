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

variable "access_entries_user_name" {
  description = "String of users with access to the cluster"
  type = string
  default = null
}
variable "access_entries_principal_arn" {
  description = "arn of the role with access to the cluster"
  type = string
  default = null
}
variable "policy_associations_default_policy_arn" {
  description = "arn og the cluster access policy"
  type = string
  default = null
}
