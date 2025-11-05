
output "resource_id" {
  description = "The resource ID of the virtual network."
  value       = module.avm_res_network_virtualnetwork.resource_id
}

output "subnet_ids_by_name" {
  description = "Map of subnet names to their resource IDs"
  value = {
    for k, s in var.subnets_definition :
    s.name => "${module.avm_res_network_virtualnetwork.resource_id}/subnets/${s.name}"
  }
}