resource "nullplatform_api_key" "nullplatform_agent_api_key" {
  name = "NULLPLATFORM-${upper(var.destination)}-API-KEY"

  grants {
    nrn       = replace(var.nrn, ":namespace=.*$", "")
    role_slug = "controlplane:agent"
  }
  grants {
    nrn       = replace(var.nrn, ":namespace=.*$", "")
    role_slug = "developer"
  }
  grants {
    nrn       = replace(var.nrn, ":namespace=.*$", "")
    role_slug = "ops"
  }
  grants {
    nrn       = replace(var.nrn, ":namespace=.*$", "")
    role_slug = "secops"
  }
  grants {
    nrn       = replace(var.nrn, ":namespace=.*$", "")
    role_slug = "secrets-reader"
  }

  tags {
    key   = "managed-by"
    value = "IaC"
  }
}