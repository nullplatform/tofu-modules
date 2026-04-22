output "vnet_id" {
  description = "The resource ID of the virtual network"
  value       = module.avm_res_network_virtualnetwork.resource_id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.avm_res_network_virtualnetwork.name
}

output "subnet_ids" {
  description = "Map of subnet names to their resource IDs"
  value = {
    for k, s in var.subnets_definition :
    s.name => "${module.avm_res_network_virtualnetwork.resource_id}/subnets/${s.name}"
  }
}
