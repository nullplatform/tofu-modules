output "public_gateway_firewall_name" {
  description = "The name of the public gateway HTTPS firewall rule."
  value       = var.gateways_enabled ? google_compute_firewall.public_gateway_https[0].name : ""
}

output "private_gateway_firewall_name" {
  description = "The name of the private gateway HTTPS firewall rule."
  value       = var.gateway_internal_enabled ? google_compute_firewall.private_gateway_https[0].name : ""
}
