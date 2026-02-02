################################################################################
# Nullplatform API Key Module Variables
################################################################################

variable "type" {
  description = "Type of API key to create. Determines the pre-configured grants and tags. Use 'custom' to define your own roles and tags."
  type        = string

  validation {
    condition     = contains(["agent", "scope_notification", "service_notification", "custom"], var.type)
    error_message = "type must be one of: agent, scope_notification, service_notification, custom"
  }
}

variable "nrn" {
  description = "Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789)"
  type        = string
}

variable "specification_slug" {
  description = "Specification slug used for the usedBy tag (required for scope_notification and service_notification types)"
  type        = string
  default     = null
}

################################################################################
# Custom type variables
################################################################################

variable "custom_name" {
  description = "Name for the API key (required when type is 'custom')"
  type        = string
  default     = null
}

variable "custom_role_slugs" {
  description = "List of role slugs to assign (required when type is 'custom', must have at least 1)"
  type        = list(string)
  default     = []
}

variable "custom_tags" {
  description = "Additional tags to apply to the API key (optional, only used when type is 'custom')"
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}
