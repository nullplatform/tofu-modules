################################################################################
# Scope Definition Module Variables
################################################################################

variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name (organization:account format)"
  default = null
}

variable "agent_tags" {
  type        = map(string)
  description = "Agent tags"

}

variable "channel_sources" {
  type        = list(string)
  description = "List of sources for the notification channel (e.g., ['monitoring', 'alerts'])"
  default = [ "telemetry", "service" ]
}

variable "channel_type" {
  type        = string
  description = "Type of the notification channel (e.g., 'agent')"
  default     = "agent"
  
}

variable "agent_api_key" {
  type        = string
  description = "API key with permsissions to run commands on agents (usually ops permisions)"
  sensitive   = true 
}

variable "scope_slug" {
  type        = string
  description = "The slug of the scope definition"  
  default = null
}
variable "workflow_override_path" {
  type = string
  default = null
  description = "Path to a custom workflow file to override the default one"
  
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
  type = string
  default = "null"
  description = "Values to override in the workflow file"
  
}

variable "scope_provider_id" {
  type        = string
  description = "The ID of the scope provider associated with the scope definition"
  default     = null
  
}

variable "scope_definition" {
  type = object({
    slug = string,
    nrn = string,
    workflow_override_path = string,
    workflow_override_values = string,
    scope_provider_id = string,
    specification = object({
      agent_command = object({
        type = string
        data = object({
          cmdline     = string
          arguments   = optional(list(string), [])
          environment = optional(map(string), {})
        })
      })  
    })
  })
}

locals {
  base_config = {
    nrn                      = var.nrn
    agent_tags               = var.agent_tags
    channel_sources          = var.channel_sources
    channel_type             = var.channel_type
    agent_api_key            = var.agent_api_key
    slug                     = var.scope_slug
    scope_provider_id        = var.scope_provider_id
    agent_command            = var.agent_command
    workflow_override_path   = var.workflow_override_path
    workflow_override_values = var.workflow_override_values
  }
  
  merged_config = merge(
    local.base_config,
    {
      for k, v in var.scope_definition : k => (
        # If key exists in base_config and scope_definition value is null,
        # keep the base_config value, otherwise use scope_definition value
        contains(keys(local.base_config), k) && v == null 
          ? local.base_config[k] 
          : v
      )
    }
  )
}