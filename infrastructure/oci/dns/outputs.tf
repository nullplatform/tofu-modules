output "dns_zones" {
  description = "Map of created DNS zones with their details"
  value = {
    for key, zone in oci_dns_zone.zones : key => {
      id           = zone.id
      name         = zone.name
      zone_type    = zone.zone_type
      state        = zone.state
      self_uri     = zone.self
      serial       = zone.serial
      version      = zone.version
      nameservers  = zone.nameservers
      time_created = zone.time_created
    }
  }
}

output "dns_zone_ids" {
  description = "Map of DNS zone names to their OCIDs"
  value       = { for key, zone in oci_dns_zone.zones : key => zone.id }
}

output "dns_zone_nameservers" {
  description = "Map of DNS zone names to their nameservers"
  value       = { for key, zone in oci_dns_zone.zones : key => zone.nameservers }
}
