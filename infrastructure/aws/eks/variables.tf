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
  default     = "1.34"
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

variable "ami_release_version" {
  description = <<-EOT
    Pin a specific AMI release version for the managed node group (e.g. "1.34.6-20260415").
    When null, the upstream module resolves the AMI based on use_latest_ami_release_version.
    Set this to a fixed value when reproducible AMIs are required (e.g. to avoid plan drift
    every time AWS publishes a new optimized AMI).
  EOT
  type        = string
  default     = null
}

variable "use_latest_ami_release_version" {
  description = <<-EOT
    If true, the upstream module looks up the latest AMI release version from the SSM
    parameter `/aws/service/eks/optimized-ami/.../recommended/release_version` on every plan,
    which surfaces drift whenever AWS publishes a new AMI. When null, defers to the upstream
    default (true in terraform-aws-modules/eks v21+). Set to false together with
    ami_release_version to pin the AMI to an explicit value.
  EOT
  type        = bool
  default     = null
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

variable "endpoint_public_access_cidrs" {
  description = "List of CIDR blocks allowed to access the public EKS API server endpoint"
  type        = list(string)
  default     = []
  validation {
    condition     = var.endpoint_public_access == false || length(var.endpoint_public_access_cidrs) > 0
    error_message = "endpoint_public_access_cidrs is required when endpoint_public_access is 'true'."
  }
}

variable "security_group_additional_rules" {
  description = "Whether to create additional security group rules for NLB health checks and HTTPS traffic"
  type        = bool
  default     = true
}

variable "additional_network_cidrs" {
  type        = list(string)
  description = "Additional CIDR blocks to allow in security group rules (e.g., peered VPC, on-premises network)."
  default     = []
}

variable "authentication_mode" {
  description = "Authentication mode for the EKS cluster. Valid values: CONFIG_MAP, API, API_AND_CONFIG_MAP."
  type        = string
  default     = "API_AND_CONFIG_MAP"

  validation {
    condition     = contains(["CONFIG_MAP", "API", "API_AND_CONFIG_MAP"], var.authentication_mode)
    error_message = "authentication_mode must be one of: CONFIG_MAP, API, API_AND_CONFIG_MAP."
  }
}

# ============================================================================
# Control Plane Logging
# ============================================================================

variable "enabled_log_types" {
  description = "List of EKS control plane log types to enable. Valid values: api, audit, authenticator, controllerManager, scheduler"
  type        = list(string)
  default     = []
}

variable "create_cloudwatch_log_group" {
  description = "Whether to create a CloudWatch log group for cluster logs. If false and logging is enabled, AWS creates it automatically but outside of Terraform management."
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events in the CloudWatch log group"
  type        = number
  default     = 90
}
