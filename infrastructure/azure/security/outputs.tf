output "public_gateway_nsg_id" {
  description = "The ID of the public gateway NSG."
  value       = var.gateways_enabled ? azurerm_network_security_group.public_gateway[0].id : ""
}

output "private_gateway_nsg_id" {
  description = "The ID of the private gateway NSG."
  value       = var.gateway_internal_enabled ? azurerm_network_security_group.private_gateway[0].id : ""
}
