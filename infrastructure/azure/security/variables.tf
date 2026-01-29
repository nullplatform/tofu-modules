variable "cluster_name" {
  type        = string
  description = "The AKS cluster name, used for naming security resources and deriving VNet."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name for NSG resources."
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

variable "azure_location" {
  type        = string
  description = "Override: The Azure region. If empty, derived automatically from cluster."
  default     = ""
}

variable "network_cidr" {
  type        = string
  description = "Override: The network CIDR block. If empty, derived automatically from VNet."
  default     = ""
}
