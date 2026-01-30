locals {
  zone_name = var.dns_zone_name != null ? var.dns_zone_name : replace(var.domain_name, ".", "-")
}

resource "google_dns_managed_zone" "zone" {
  project    = var.project_id
  name       = local.zone_name
  dns_name   = "${var.domain_name}."
  visibility = var.visibility

  dynamic "private_visibility_config" {
    for_each = var.visibility == "private" ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.vpc_ids
        content {
          network_url = networks.value
        }
      }
    }
  }

  labels = var.tags
}
