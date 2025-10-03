resource "azurerm_dns_zone" "public_dns_zone" {
  name                = var.domain_name
  resource_group_name = var.resource_group
}
