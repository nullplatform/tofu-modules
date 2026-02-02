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

variable "use_auto_mode" {
  description = "Use EKS Auto Mode (true) or Managed Node Groups (false)"
  type        = bool
  default     = false
}

variable "auto_mode_node_pools" {
  description = "Node pools for Auto Mode. Valid values are 'general-purpose' and 'system'."
  type        = list(string)
  default     = ["general-purpose", "system"]

  validation {
    condition = alltrue([
      for pool in var.auto_mode_node_pools : contains(["general-purpose", "system"], pool)
    ])
    error_message = "auto_mode_node_pools must only contain 'general-purpose' and/or 'system'."
  }
}


variable "attach_cluster_primary_security_group" {
  description = "Attach cluster primary security group to node groups"
  type        = bool
  default     = true
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the managed node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the managed node group"
  type        = number
  default     = 10
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the managed node group"
  type        = number
  default     = 2
}

variable "endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = false
}