resource "google_dns_managed_zone" "zone" {
  project    = var.project_id
  name       = var.zone_name
  dns_name   = "${var.domain_name}."
  visibility = var.visibility

  dynamic "private_visibility_config" {
    for_each = var.visibility == "private" ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.private_zone_networks
        content {
          network_url = networks.value
        }
      }
    }
  }
}
