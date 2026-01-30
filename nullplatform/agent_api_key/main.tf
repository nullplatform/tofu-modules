resource "nullplatform_api_key" "this" {
  name = "AGENT"

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "controlplane:agent"
  }

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "developer"
  }

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "ops"
  }

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "secops"
  }

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "secrets-reader"
  }

  tags {
    key   = "managedBy"
    value = "IaC"
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
