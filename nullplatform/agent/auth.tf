################################################################################
# Nullplatform agent API key
################################################################################

module "api_key" {
  source = "../api_key"

  name = "NULLPLATFORM-AGENT-${var.cluster_name}-API-KEY"

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
      key   = "owner"
      value = var.nrn
    },
    {
      key   = "source"
      value = "tofu-modules/nullplatform/agent"
    }
  ]
}
