################################################################################
# Nullplatform Authorization API Key
################################################################################

locals {
  nrn_without_namespace = replace(var.nrn, ":namespace=.*$", "")
}

module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.24.0"

  name = "${upper(var.destination)}-AUTH"

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
      key   = "managedBy"
      value = "IaC"
    },
    {
      key   = "usedBy"
      value = "${upper(var.destination)}"
    }
  ]
}
