resource "azurerm_resource_group" "nullplatform_resource_group" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}