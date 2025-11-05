###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "vnet_name" {
  type        = string
  description = "The name of the Virtual Network"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the VNet will be created"
}

variable "location" {
  type        = string
  description = "The Azure region where the VNet should be created (e.g., eastus, westus2)"
}

variable "address_space" {
  type        = set(string)
  description = "The address space (CIDR blocks) for the Virtual Network (e.g., [\"10.0.0.0/16\"])"
}

variable "subnets_definition" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  description = "Map of subnets to create within the VNet. Each subnet requires a name and address_prefixes."
}
# Example:
# subnets_definition = {
#   subnet1 = {
#     name             = "subnet-aks"
#     address_prefixes = ["10.0.0.0/24"]
#   }
#   subnet2 = {
#     name             = "subnet-services"
#     address_prefixes = ["10.0.1.0/24"]
#   }
# }

variable "subscription_id" {
  type        = string
  description = "The ID of your Azure Subscription"
}

###############################################################################
# OPTIONAL VARIABLES - TAGS
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the VNet and subnets"
  default     = {}
}