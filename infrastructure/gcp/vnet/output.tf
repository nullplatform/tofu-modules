output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.vpc.network_name
}

output "vnet_id" {
  description = "The self-link of the virtual network"
  value       = module.vpc.network_self_link
}

output "subnet_names" {
  description = "The names of the subnets created in the virtual network"
  value       = module.vpc.subnets_names
}

output "subnet_ids" {
  description = "The self-links of the subnets created in the virtual network"
  value       = module.vpc.subnets_self_links
}
