################################################################################
# Nullplatform API Key Module
################################################################################

resource "nullplatform_api_key" "this" {
  name = local.config.name

  dynamic "grants" {
    for_each = local.grants
    content {
      nrn       = grants.value.nrn
      role_slug = grants.value.role_slug
    }
  }

  dynamic "tags" {
    for_each = local.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
