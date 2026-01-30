output "public_gateway_security_group_id" {
  description = "The ID of the public gateway security group."
  value       = var.gateways_enabled ? aws_security_group.public_gateway[0].id : ""
}

output "private_gateway_security_group_id" {
  description = "The ID of the private gateway security group."
  value       = var.gateway_internal_enabled ? aws_security_group.private_gateway[0].id : ""
}
