###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to create"
}

variable "location" {
  type        = string
  description = "The Azure region where the resource group should be created (e.g., eastus, westus2)"
}

variable "subscription_id" {
  type        = string
  description = "The ID of your Azure subscription"
}

###############################################################################
# OPTIONAL VARIABLES - TAGS
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource group"
  default     = {}
}