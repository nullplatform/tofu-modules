################################################################################
# Nullplatform API Key Module
################################################################################

resource "nullplatform_api_key" "this" {
  name = var.name

  dynamic "grants" {
    for_each = var.grants
    content {
      nrn       = grants.value.nrn
      role_slug = grants.value.role_slug
    }
  }

  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
