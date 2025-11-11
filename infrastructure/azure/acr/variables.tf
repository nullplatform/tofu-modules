variable "location" {
  type        = string
  description = "The location or region where the resource group should be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "containerregistry_name" {
  type        = string
  description = "The name of the ACR (must be globally unique, lowercase alphanumeric only, 5–50 characters)"

  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.containerregistry_name))
    error_message = "ACR name must be 5-50 characters long, and contain only lowercase letters and numbers."
  }
}

variable "subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

variable "sku" {
  type        = string
  description = "The SKU of the container registry. Possible values: Basic, Standard, Premium"
  default     = "Basic"
}

variable "zone_redundancy_enabled" {
  type        = bool
  description = "Whether to enable zone redundancy for the container registry (requires Premium SKU)"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the ACR resource"
  default     = {}
}