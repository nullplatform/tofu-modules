
module "avm-res-network-virtualnetwork" {
  source              = "azure/avm-res-network-virtualnetwork/azurerm"
  version             = "v0.10.0"
  address_space       = var.address_space
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnets             = var.subnets_definition
}


