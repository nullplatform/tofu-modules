################################################################################
# Nullplatform Agent Association API Key
################################################################################

# Create API key for agent association
resource "nullplatform_api_key" "nullplatform_agent_api_key" {
  name = "SCOPE_DEFINITION_AGENT_ASSOCIATION"

  # Grant control plane agent role for agent operations
  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "controlplane:agent"
  }

  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "ops"
  }

  tags {
    key   = "managed-by"
    value = "IaC"
  }
}