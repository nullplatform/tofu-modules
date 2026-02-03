################################################################################
# Scope Definition Module Variables
################################################################################

variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name (organization:account format)"
  default     = null
}

variable "api_key" {
  description = "API key for authenticating with the nullplatform API"
  type        = string
  sensitive   = true
}

variable "tags_selectors" {
  description = "Map of tags used to select and filter agents"
  type        = map(string)
}


variable "channel_sources" {
  type        = list(string)
  description = "List of sources for the notification channel (e.g., ['monitoring', 'alerts'])"
  default     = ["telemetry", "service"]
}

variable "channel_type" {
  type        = string
  description = "Type of the notification channel (e.g., 'agent')"
  default     = "agent"

}

variable "service_specification_slug" {
  type        = string
  description = "The slug of the service definition"
  default     = null
}
variable "workflow_override_path" {
  type        = string
  default     = null
  description = "Path to a custom workflow file to override the default one"

}

variable "service_path" {
  type        = string
  default     = null
  description = "Path to the service configuration"

}
variable "agent_command" {
  type = object({
    type = string
    data = object({
      cmdline     = string
      arguments   = optional(list(string), [])
      environment = optional(map(string), {})
    })
  })
  default = null

}

variable "workflow_override_values" {
  type        = string
  default     = "null"
  description = "Values to override in the workflow file"

}

variable "service_specification_id" {
  type        = string
  description = "The ID of the service definition associated with the agent"
  default     = null
}
