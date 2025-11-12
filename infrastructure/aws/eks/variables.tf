variable "name" {
  type        = string
  description = "Cluster name"
}

variable "ami_type" {
  type        = string
  description = "AMI type to use with the node"
  default     = "AL2023_x86_64_STANDARD"
}

variable "instance_types" {
  type        = string
  description = "Instance type to use"
  default     = "t3.medium"
}

variable "kubernetes_version" {
  type        = string
  description = "K8s version to use"
  default     = "1.32"
}

variable "aws_vpc_vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "aws_subnets_private_ids" {
  description = "List of private subnet IDs for the EKS cluster and node groups"
  type        = list(string)
}

variable "access_entries" {
  description = "Map of access entries for the EKS cluster"
  type = map(object({
    principal_arn     = string
    user_name         = optional(string)
    kubernetes_groups = optional(list(string))
    type              = optional(string)

    policy_associations = optional(map(object({
      policy_arn = string
      access_scope = optional(object({
        type       = optional(string)
        namespaces = optional(list(string))
      }))
    })))
  }))
  default = {}
}
