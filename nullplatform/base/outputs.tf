############################################
# Security AWS Outputs
############################################

output "public_gateway_security_group_id" {
  description = "The ID of the public gateway security group (AWS)"
  value       = var.gateway_public_aws_security_group_id
}

output "private_gateway_security_group_id" {
  description = "The ID of the private gateway security group (AWS)"
  value       = var.gateway_private_aws_security_group_id
}

############################################
# Security Azure Outputs
############################################

output "public_gateway_nsg_id" {
  description = "The ID of the public gateway NSG (Azure)"
  value       = var.gateway_public_azure_nsg_id
}

output "private_gateway_nsg_id" {
  description = "The ID of the private gateway NSG (Azure)"
  value       = var.gateway_private_azure_nsg_id
}

############################################
# Security GCP Outputs
############################################

output "public_gateway_firewall_name" {
  description = "The name of the public gateway firewall rule (GCP)"
  value       = var.gateway_public_gcp_firewall_name
}

output "private_gateway_firewall_name" {
  description = "The name of the private gateway firewall rule (GCP)"
  value       = var.gateway_private_gcp_firewall_name
}
