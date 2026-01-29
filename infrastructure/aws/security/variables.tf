variable "cluster_name" {
  type        = string
  description = "The EKS cluster name, used for naming security resources and deriving VPC."
}

variable "gateways_enabled" {
  type        = bool
  description = "Whether public gateways are enabled."
  default     = true
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Whether the internal (private) gateway is enabled."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "Override: The VPC ID. If empty, derived automatically from cluster name."
  default     = ""
}

variable "network_cidr" {
  type        = string
  description = "Override: The network CIDR block. If empty, derived automatically from VPC."
  default     = ""
}
