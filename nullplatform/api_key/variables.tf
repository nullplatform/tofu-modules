################################################################################
# Nullplatform API Key Module Variables
################################################################################

variable "type" {
  description = "Type of API key to create. Determines the pre-configured grants and tags."
  type        = string

  validation {
    condition     = contains(["agent", "scope_notification", "service_notification"], var.type)
    error_message = "type must be one of: agent, scope_notification, service_notification"
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
