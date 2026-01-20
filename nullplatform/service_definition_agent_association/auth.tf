################################################################################
# Nullplatform Service Definition Agent Association API Key
################################################################################

locals {
  nrn_without_namespace = replace(var.nrn, ":namespace=.*$", "")
}

module "api_key" {
  source = "../api_key"

  name = "SERVICE_DEFINITION_AGENT_ASSOCIATION-${upper(var.service_slug)}"

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
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "secops"
    }
  ]

  tags = [
    {
      key   = "managed-by"
      value = "IaC"
    },
    {
      key   = "source"
      value = "tofu-modules/nullplatform/service_definition_agent_association"
    }
  ]
}
