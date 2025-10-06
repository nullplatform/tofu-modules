resource "nullplatform_api_key" "nullplatform-base-api-key" {
  name = "NULLPLATFORM-BASE-API-KEY"

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
    key   = "managed-by"
    value = "IaC"
  }
}