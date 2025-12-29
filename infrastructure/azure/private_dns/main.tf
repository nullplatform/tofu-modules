resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.domain_name
  resource_group_name = var.resource_group
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  for_each = { for idx, link in var.virtual_network_links : idx => link }

  name                  = "vnet-link-${each.key}"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = each.value.registration_enabled
  tags                  = var.tags
}
