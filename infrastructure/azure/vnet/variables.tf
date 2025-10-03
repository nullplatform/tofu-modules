variable "location" {
  type        = string
  description = "The location/region where the resource group should be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "vnet_name" {
  type        = string
  description = "The name of your vnet"
}

variable "address_space" {
  type        = set(string)
  description = "The cidr of your vnet"
}

variable "subnets_definition" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  description = "The subnet definition for the vnet"
}
/*
   for example
   {
    "subnet1" = {
      name             = "subnet1"
      address_prefixes = ["10.0.0.0/24"]
    }
    "subnet2" = {
      name             = "subnet2"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
  */

variable "subscription_id" {
  type        = string
  description = "The id of your azure suscription"

}