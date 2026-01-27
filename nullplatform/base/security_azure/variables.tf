variable "cluster_name" {
  type        = string
  description = "The AKS cluster name."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name for NSG resources."
}

variable "azure_location" {
  type        = string
  description = "Override: The Azure region. If empty, derived automatically from cluster."
  default     = ""
}

variable "network_cidr" {
  type        = string
  description = "Override: The network CIDR block for restricting health check access. If empty, derived automatically from cluster's VNet."
  default     = ""
}

variable "gateways_enabled" {
  type        = bool
  description = "Enable public gateway NSG."
  default     = true
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Enable private gateway NSG."
  default     = false
}
