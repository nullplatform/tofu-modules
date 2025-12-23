################################################################################
# Nullplatform Agent Association API Key
################################################################################

# Create API key for agent association with minimal required permissions
resource "nullplatform_api_key" "nullplatform_agent_api_key" {
  name = "AGENT-ASSOCIATION"

  # Grant control plane agent role for agent operations
  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "controlplane:agent"
  }

  tags {
    key   = "managed-by"
    value = "IaC"
  }
}