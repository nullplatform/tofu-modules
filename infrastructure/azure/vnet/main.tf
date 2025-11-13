
module "avm_res_network_virtualnetwork" {
  source              = "azure/avm-res-network-virtualnetwork/azurerm"
  version             = "v0.15.0"
  address_space       = var.address_space
  name                = var.vnet_name
  location            = var.location
  subnets             = var.subnets_definition
  parent_id           = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
}


