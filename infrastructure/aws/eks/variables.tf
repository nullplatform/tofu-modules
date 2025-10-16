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

variable "access_entries" {
  description = "Map de access entries para el cluster EKS"
  type = map(object({
    user_name     = string
    principal_arn = string

    policy_associations = map(object({
      policy_arn = string
      access_scope = object({
        type       = string
        namespaces = optional(list(string))
      })
    }))
    kubernetes_groups = optional(list(string))
    type             = optional(string)
  }))

  default = {}
}
