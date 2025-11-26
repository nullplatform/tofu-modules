###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the virtual network will be created"
}

variable "location" {
  type        = string
  description = "The Azure region where the virtual network will be created (e.g., eastus, westus2)"
}

variable "address_space" {
  type        = set(string)
  description = "The address space (CIDR blocks) for the virtual network (e.g., [\"10.0.0.0/16\"])"
}

variable "subnets_definition" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  description = "A map of subnets to create within the virtual network. Each subnet requires a name and address_prefixes."
}

# Example:
# subnets_definition = {
#   subnet1 = {
#     name             = "subnet-1"
#     address_prefixes = ["10.0.0.0/24"]
#   }
#   subnet2 = {
#     name             = "subnet-2"
#     address_prefixes = ["10.0.1.0/24"]
#   }
# }

variable "subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}