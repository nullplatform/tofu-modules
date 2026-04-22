output "dns_zone_name" {
  description = "The name of the created DNS zone"
  value       = azurerm_dns_zone.public_dns_zone.name
}

output "dns_zone_id" {
  description = "The ID of the DNS zone"
  value       = azurerm_dns_zone.public_dns_zone.id
}

output "private_dns_zone_name" {
  description = "The name of the created private DNS zone"
  value       = azurerm_dns_zone.public_dns_zone.name
}

output "private_dns_zone_id" {
  description = "The ID of the created private DNS zone"
  value       = azurerm_dns_zone.public_dns_zone.id
}

output "name_servers" {
  description = "The list of name servers for the DNS zone"
  value       = azurerm_dns_zone.public_dns_zone.name_servers
}
