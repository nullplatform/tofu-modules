################################################################################
# Nullplatform Scope Definition Agent Association API Key
################################################################################

module "api_key" {
  source = "../api_key"

  name = "SCOPE-NOTIFICATION-CHANNEL-${upper(var.scope_specification_slug)}"

  grants = [
    {
      nrn       = local.nrn_without_namespace
      role_slug = "controlplane:agent"
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "ops"
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
    },
    {
      key   = "usedBy"
      value = "${upper(var.scope_specification_slug)}"
    }
  ]
}