data "azurerm_container_registry" "acr" {
  name                = var.containerregistry_name
  resource_group_name = var.resource_group_name
  depends_on          = [module.containerregistry]
}