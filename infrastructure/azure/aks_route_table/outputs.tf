output "route_table_id" {
  description = "The resource ID of the AKS-managed route table"
  value       = data.azurerm_resources.aks_route_table.resources[0].id
}
