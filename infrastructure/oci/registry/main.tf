# -----------------------------------------------------------------------
# Container Repositories (OCIR)
# -----------------------------------------------------------------------
resource "oci_artifacts_container_repository" "repositories" {
  for_each = var.container_repositories

  compartment_id = var.compartment_id
  display_name   = each.value.display_name
  is_public      = each.value.is_public
  is_immutable   = each.value.is_immutable

  dynamic "readme" {
    for_each = each.value.readme != null ? [each.value.readme] : []
    content {
      content = readme.value.content
      format  = readme.value.format
    }
  }

  defined_tags  = merge(var.defined_tags, each.value.defined_tags)
  freeform_tags = merge(var.freeform_tags, each.value.freeform_tags)

  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
    ]
  }
}
