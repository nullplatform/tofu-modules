resource "nullplatform_api_key" "nullplatform-agent-api-key" {
  name = "NULLPLATFORM-AGENT-API-KEY"

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