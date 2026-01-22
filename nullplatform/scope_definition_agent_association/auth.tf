################################################################################
# Nullplatform Scope Definition Agent Association API Key
################################################################################

module "api_key" {
  source = "../api_key"

  name = "SCOPE_${upper(var.service_specification_slug)}_CHANNEL"

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
      value = "${upper(var.service_specification_slug)}"
    }
  ]
}
