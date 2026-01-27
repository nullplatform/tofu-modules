############################################
# Security AWS Outputs
############################################

output "public_gateway_security_group_id" {
  description = "The ID of the public gateway security group (AWS)"
  value       = var.k8s_provider == "eks" ? module.security_aws[0].public_gateway_security_group_id : null
}

output "private_gateway_security_group_id" {
  description = "The ID of the private gateway security group (AWS)"
  value       = var.k8s_provider == "eks" ? module.security_aws[0].private_gateway_security_group_id : null
}

############################################
# Security Azure Outputs
############################################

output "public_gateway_nsg_id" {
  description = "The ID of the public gateway NSG (Azure)"
  value       = contains(["aks", "aro"], var.k8s_provider) ? module.security_azure[0].public_gateway_nsg_id : null
}

output "public_gateway_nsg_name" {
  description = "The name of the public gateway NSG (Azure)"
  value       = contains(["aks", "aro"], var.k8s_provider) ? module.security_azure[0].public_gateway_nsg_name : null
}

output "private_gateway_nsg_id" {
  description = "The ID of the private gateway NSG (Azure)"
  value       = contains(["aks", "aro"], var.k8s_provider) ? module.security_azure[0].private_gateway_nsg_id : null
}

output "private_gateway_nsg_name" {
  description = "The name of the private gateway NSG (Azure)"
  value       = contains(["aks", "aro"], var.k8s_provider) ? module.security_azure[0].private_gateway_nsg_name : null
}

############################################
# Security GCP Outputs
############################################

output "public_gateway_firewall_rules" {
  description = "The names of the public gateway firewall rules (GCP)"
  value       = var.k8s_provider == "gke" ? module.security_gcp[0].public_gateway_firewall_rules : null
}

output "private_gateway_firewall_rules" {
  description = "The names of the private gateway firewall rules (GCP)"
  value       = var.k8s_provider == "gke" ? module.security_gcp[0].private_gateway_firewall_rules : null
}
