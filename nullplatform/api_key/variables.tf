################################################################################
# Nullplatform API Key Module Variables
################################################################################

variable "type" {
  description = "Type of API key to create. Determines the pre-configured grants and tags. 'base' carries the agent roles minus secrets-reader, for the nullplatform base module. Use 'custom' to define your own roles and tags."
  type        = string

  validation {
    condition     = contains(["agent", "base", "scope_notification", "service_notification", "custom"], var.type)
    error_message = "type must be one of: agent, base, scope_notification, service_notification, custom"
  }
}

variable "nrn" {
  description = "Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789). Required for predefined types (agent, base, scope_notification, service_notification). Optional for custom type when using custom_grants."
  type        = string
  default     = null
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
  description = "List of role slugs to assign using the module-level NRN (used when type is 'custom' and custom_grants is empty)"
  type        = list(string)
  default     = []
}

variable "custom_grants" {
  description = "List of grants with explicit NRN and role_slug pairs. Allows assigning different NRNs per grant (used when type is 'custom')."
  type = list(object({
    nrn       = string
    role_slug = string
  }))
  default = []
}

variable "custom_tags" {
  description = "Additional tags to apply to the API key (optional, only used when type is 'custom')"
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}

################################################################################
# Visibility
################################################################################

variable "internal" {
  description = "Marks the API key as internal to nullplatform, keeping it out of the API key listing (`GET /api_key` and the UI) while it stays readable by ID — for the plumbing credentials this module creates (agents, notification channels) rather than keys a person manages. Create-only in the API, so changing it replaces the key and rotates its secret. Leave unset for the platform default (not internal)."
  type        = bool
  default     = null
}
