resource "nullplatform_api_key" "this" {
  name = "SERVICE-NOTIFICATION-CHANNEL-POSTGRESQL"

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "controlplane:agent"
  }

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "admin"
  }

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "ops"
  }

  tags {
    key   = "managedBy"
    value = "IaC"
  }

  tags {
    key   = "usedBy"
    value = "POSTGRESQL"
  }

  dynamic "tags" {
    for_each = local.nrn_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
