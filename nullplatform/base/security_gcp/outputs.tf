output "public_gateway_firewall_rules" {
  description = "The names of the public gateway firewall rules"
  value = var.gateways_enabled ? {
    https        = google_compute_firewall.public_gateway_https[0].name
    health_check = google_compute_firewall.public_gateway_health_check[0].name
    deny_health  = google_compute_firewall.public_gateway_deny_health_check[0].name
  } : null
}

output "private_gateway_firewall_rules" {
  description = "The names of the private gateway firewall rules"
  value = var.gateway_internal_enabled ? {
    https        = google_compute_firewall.private_gateway_https[0].name
    health_check = google_compute_firewall.private_gateway_health_check[0].name
  } : null
}
