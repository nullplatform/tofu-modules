resource "nullplatform_api_key" "this" {
  name = "SCOPE-NOTIFICATION-CHANNEL-K8S"

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "controlplane:agent"
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
    value = "K8S"
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
