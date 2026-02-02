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

    precondition {
      condition     = var.type != "custom" || (var.custom_name != null && var.custom_name != "")
      error_message = "custom_name is required when type is 'custom'"
    }

    precondition {
      condition     = var.type != "custom" || length(var.custom_role_slugs) > 0
      error_message = "custom_role_slugs must have at least 1 role when type is 'custom'"
    }
  }
}
