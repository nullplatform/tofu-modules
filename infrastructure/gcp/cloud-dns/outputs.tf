output "zone_name" {
  value = google_dns_managed_zone.zone.name
}

output "name_servers" {
  value = google_dns_managed_zone.zone.name_servers
}
