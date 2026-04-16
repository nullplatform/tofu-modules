output "dns_zone_name" {
  description = "The name of the created DNS zone"
  value       = google_dns_managed_zone.zone.name
}

output "dns_zone_id" {
  description = "The ID of the created DNS zone"
  value       = google_dns_managed_zone.zone.id
}

output "name_servers" {
  description = "The list of name servers for the DNS zone"
  value       = google_dns_managed_zone.zone.name_servers
}
