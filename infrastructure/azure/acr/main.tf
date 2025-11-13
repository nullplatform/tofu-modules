module "containerregistry" {
  source                  = "azure/avm-res-containerregistry-registry/azurerm"
  version                 = "v0.4.0"
  name                    = var.containerregistry_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  admin_enabled           = true
  sku                     = var.sku
  zone_redundancy_enabled = var.zone_redundancy_enabled
  tags                    = var.tags
  retention_policy_in_days = var.retention_policy_in_days

}

