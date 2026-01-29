variable "cluster_name" {
  type        = string
  description = "The EKS cluster name."
}

variable "vpc_id" {
  type        = string
  description = "Override: The VPC ID. If empty, derived automatically from cluster name."
  default     = ""
}

variable "network_cidr" {
  type        = string
  description = "Override: The network CIDR block for restricting health check access. If empty, derived automatically from cluster's VPC."
  default     = ""
}

variable "gateways_enabled" {
  type        = bool
  description = "Enable public gateway security group."
  default     = true
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Enable private gateway security group."
  default     = false
}
