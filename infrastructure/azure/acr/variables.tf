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
variable "georeplications" {
  description = "Lista de configuraciones de geo-replicación para el ACR."
  type = list(object({
    location                  = string
    regional_endpoint_enabled = optional(bool, true)
    zone_redundancy_enabled   = optional(bool, true)
    tags                      = optional(map(any), null)
  }))
  default = []
}
locals {
  georeplications_normalized = [
    for g in var.georeplications : {
      location                  = coalesce(g.location, var.location)
      regional_endpoint_enabled = try(g.regional_endpoint_enabled, true)
      zone_redundancy_enabled   = try(g.zone_redundancy_enabled, false)
      tags                      = try(g.tags, null)
    }
  ]
}