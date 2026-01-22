################################################################################
# Nullplatform Service Definition Agent Association API Key
################################################################################

locals {
  nrn_without_namespace = replace(var.nrn, ":namespace=.*$", "")
}

module "api_key" {
  source = "../api_key"

  name = "SERVICE_DEFINITION_AGENT_ASSOCIATION"

  grants = [
    {
      nrn       = local.nrn_without_namespace
      role_slug = "controlplane:agent"
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "admin"
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
