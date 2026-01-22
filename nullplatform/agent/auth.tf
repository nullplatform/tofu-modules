################################################################################
# Nullplatform agent API key
################################################################################

module "api_key" {
  source = "../api_key"

  name = "AGENT"

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
      key   = "level"
      value = var.nrn
    }
  ]
}
