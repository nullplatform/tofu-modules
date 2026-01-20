################################################################################
# Nullplatform Scope Definition Agent Association API Key
################################################################################

module "api_key" {
  source = "../api_key"

  name = "SCOPE_DEFINITION_AGENT_ASSOCIATION"

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
      key   = "managedby"
      value = "IaC"
    },
    {
      key   = "source"
      value = "tofu-modules/nullplatform/scope_definition_agent_association"
    }
  ]
}
