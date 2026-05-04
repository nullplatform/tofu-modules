output "public_traffic_rule_id" {
  description = "ID of the ingress rule allowing public gateway traffic to the cluster SG."
  value       = length(aws_vpc_security_group_ingress_rule.cluster_from_public_gateway_traffic) > 0 ? aws_vpc_security_group_ingress_rule.cluster_from_public_gateway_traffic[0].id : ""
}

output "private_traffic_rule_id" {
  description = "ID of the ingress rule allowing private gateway traffic to the cluster SG."
  value       = length(aws_vpc_security_group_ingress_rule.cluster_from_private_gateway_traffic) > 0 ? aws_vpc_security_group_ingress_rule.cluster_from_private_gateway_traffic[0].id : ""
}
