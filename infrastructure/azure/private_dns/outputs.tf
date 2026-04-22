output "private_dns_zone_name" {
  description = "The name of the created private DNS zone"
  value       = azurerm_private_dns_zone.private_dns_zone.name
}

output "private_dns_zone_id" {
  description = "The ID of the private DNS zone"
  value       = azurerm_private_dns_zone.private_dns_zone.id
}

output "virtual_network_link_ids" {
  description = "The IDs of the virtual network links"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.vnet_link : k => v.id }
}
