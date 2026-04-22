output "network_name" {
  description = "The name of the VPC network"
  value       = module.vpc.network_name
}

output "network_self_link" {
  description = "The self-link of the VPC network"
  value       = module.vpc.network_self_link
}

output "subnets_names" {
  description = "The names of the subnets created in the VPC"
  value       = module.vpc.subnets_names
}

output "subnets_self_links" {
  description = "The self-links of the subnets created in the VPC"
  value       = module.vpc.subnets_self_links
}
