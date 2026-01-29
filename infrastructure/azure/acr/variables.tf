###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "location" {
  type        = string
  description = "The Azure region where the container registry will be created (e.g., eastus, westus2)"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the container registry will be created"
}

variable "containerregistry_name" {
  type        = string
  description = "The name of the container registry (must be globally unique, lowercase alphanumeric only, 5-50 characters)"

  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.containerregistry_name))
    error_message = "Container registry name must be 5-50 characters long, and contain only lowercase letters and numbers."
  }
}

variable "subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

###############################################################################
# OPTIONAL VARIABLES - REGISTRY CONFIGURATION
###############################################################################

variable "sku" {
  type        = string
  description = "The SKU of the container registry (Basic, Standard, Premium)"
  default     = "Basic"
}

variable "zone_redundancy_enabled" {
  type        = bool
  description = "Whether to enable zone redundancy for the container registry (requires Premium SKU)"
  default     = false
}

variable "retention_policy_in_days" {
  type        = number
  description = "The number of days to retain untagged manifests (requires Premium SKU)"
  default     = null
}

###############################################################################
# OPTIONAL VARIABLES - TAGS AND METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the container registry"
  default     = {}
}
