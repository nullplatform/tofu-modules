output "dns_zone_name" {
  description = "The name of the created DNS Zone"
  value       = azurerm_dns_zone.public_dns_zone.name
}

output "dns_zone_id" {
  description = "The ID of the DNS Zone"
  value       = azurerm_dns_zone.public_dns_zone.id
}

output "private_dns_zone_name" {
  description = "The name of the private created DNS Zone"
  value       = azurerm_dns_zone.public_dns_zone.name
}

output "private_dns_zone_id" {
  description = "The ID of the private DNS Zone"
  value       = azurerm_dns_zone.public_dns_zone.id
}

output "name_servers" {
  description = "A list of name servers"
  value       = azurerm_dns_zone.public_dns_zone.name_servers
}
