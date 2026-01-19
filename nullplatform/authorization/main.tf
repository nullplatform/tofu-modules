################################################################################
# Nullplatform Authorization API Key
################################################################################

locals {
  nrn_without_namespace = replace(var.nrn, ":namespace=.*$", "")
}

module "api_key" {
  source = "../api_key"

  name = "NULLPLATFORM-${upper(var.destination)}-AUTH-API-KEY"

  grants = [
    {
      nrn       = local.nrn_without_namespace
      role_slug = "controlplane:agent"
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "developer"
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "ops"
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "secops"
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "secrets-reader"
    }
  ]

  tags = [
    {
      key   = "managed-by"
      value = "IaC"
    },
    {
      key   = "source"
      value = "tofu-modules/nullplatform/authorization"
    }
  ]
}
