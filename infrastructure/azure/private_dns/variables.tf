###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "resource_group" {
  type        = string
  description = "The name of the resource group where the private DNS zone will be created"
}

variable "domain_name" {
  type        = string
  description = "The domain name to use for the private DNS zone (e.g., privatelink.database.windows.net)"
}

variable "subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

###############################################################################
# OPTIONAL VARIABLES - VNET LINK
###############################################################################

variable "virtual_network_links" {
  type = list(object({
    vnet_id              = string
    registration_enabled = optional(bool, false)
  }))
  description = "List of virtual networks to link to the private DNS zone. Each object requires vnet_id and optionally registration_enabled for auto-registration of VM records"
  default     = []
}

###############################################################################
# OPTIONAL VARIABLES - TAGS
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the private DNS zone"
  default     = {}
}
