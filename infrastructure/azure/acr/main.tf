module "containerregistry" {
  source              = "azure/avm-res-containerregistry-registry/azurerm"
  version             = "v0.4.0"
  name                = var.containerregistry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_enabled       = true
  georeplications     = local.georeplications_normalized
}

