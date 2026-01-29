###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "resource_group_name" {
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
# VNET LINK
###############################################################################

variable "virtual_network_links" {
  type = list(object({
    vnet_id              = string
    registration_enabled = optional(bool, false)
  }))
  description = "List of virtual networks to link to the private DNS zone. Each object requires vnet_id and optionally registration_enabled (false for AKS/Private Link, true for VMs auto-registration)"
}

#    Example:
#    virtual_network_links = [
#      {
#        vnet_id              = module.vnet.resource_id
#        registration_enabled = false  # Use false for AKS/Private Link, true only for VM auto-registration
#      }
#    ]

###############################################################################
# OPTIONAL VARIABLES - TAGS
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the private DNS zone"
  default     = {}
}
