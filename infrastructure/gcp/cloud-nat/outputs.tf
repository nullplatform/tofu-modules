output "router_name" {
  description = "The name of the created Cloud Router"
  value       = google_compute_router.router.name
}

output "nat_name" {
  description = "The name of the created Cloud NAT gateway"
  value       = google_compute_router_nat.nat.name
}
