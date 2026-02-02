# -----------------------------------------------------------------------
# DNS Zones
# -----------------------------------------------------------------------
resource "oci_dns_zone" "zones" {
  for_each = var.dns_zones

  compartment_id = var.compartment_id
  name           = each.value.name
  zone_type      = each.value.zone_type
  scope          = each.value.scope

  dynamic "external_masters" {
    for_each = each.value.zone_type == "SECONDARY" ? each.value.external_masters : []
    content {
      address     = external_masters.value.address
      port        = external_masters.value.port
      tsig_key_id = external_masters.value.tsig_key_id
    }
  }

  view_id = each.value.view_id

  defined_tags  = merge(var.defined_tags, each.value.defined_tags)
  freeform_tags = merge(var.freeform_tags, each.value.freeform_tags)

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }

  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
    ]
  }
}
