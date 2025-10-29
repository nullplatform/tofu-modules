################################################################################
# Nullplatform Agent API Key
################################################################################

# Create API key for agent authentication with required role grants
resource "nullplatform_api_key" "nullplatform_agent_api_key" {
  name = "NULLPLATFORM-AGENT-API-KEY"

  # Grant control plane agent role for core agent operations
  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "controlplane:agent"
  }

  # Grant developer role for application deployment operations
  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "developer"
  }

  # Grant ops role for operational and maintenance tasks
  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "ops"
  }

  # Grant secops role for security operations and compliance
  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "secops"
  }
  # Grant secrets-reader role for accessing application secrets
  grants {
    nrn       = local.nrn_without_namespace
    role_slug = "secrets-reader"
  }

  tags {
    key   = "managed-by"
    value = "IaC"
  }
}