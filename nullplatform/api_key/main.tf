################################################################################
# Nullplatform API Key Module
################################################################################

resource "nullplatform_api_key" "this" {
  name     = local.config.name
  internal = var.internal

  dynamic "grants" {
    for_each = tomap({ for idx, grant in local.grants : tostring(idx) => grant })
    content {
      nrn       = grants.value.nrn
      role_slug = grants.value.role_slug
    }
  }

  dynamic "tags" {
    for_each = local.tags
    content {
      key   = tags.key
      value = tags.value
    }
  }

  lifecycle {
    create_before_destroy = true

    precondition {
      condition     = var.type != "custom" || (var.custom_name != null && var.custom_name != "")
      error_message = "custom_name is required when type is 'custom'"
    }

    precondition {
      condition     = var.type != "custom" || length(var.custom_role_slugs) > 0 || length(var.custom_grants) > 0
      error_message = "custom_role_slugs or custom_grants must have at least 1 entry when type is 'custom'"
    }

    precondition {
      condition     = var.type == "custom" || var.nrn != null
      error_message = "nrn is required for predefined types (agent, base)"
    }

    precondition {
      condition     = var.type != "custom" || length(var.custom_grants) == 0 || var.nrn == null
      error_message = "when using custom_grants, do not set nrn — define the NRN per grant entry instead"
    }

    precondition {
      condition     = var.type != "custom" || length(var.custom_grants) == 0 || length(var.custom_role_slugs) == 0
      error_message = "use either custom_role_slugs or custom_grants, not both"
    }
  }
}
