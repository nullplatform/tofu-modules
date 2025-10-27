variable "location" {
  type        = string
  description = "The location/region where the resource group should be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "containerregistry_name" {
  type        = string
  description = "The name of your ACR"

}

variable "subscription_id" {
  type        = string
  description = "The ID of your Azure Suscription"

}

variable "sku" {
  type    = string
  default = "Premium"

}
variable "zone_redundancy_enabled" {
  type    = bool
  default = false

}