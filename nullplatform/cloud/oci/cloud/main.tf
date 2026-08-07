resource "nullplatform_provider_config" "oci" {
  nrn  = var.nrn
  type = "oci-configuration"

  dimensions = var.dimensions

  # `authentication` was dropped: it doesn't exist in the "oci-configuration"
  # provider specification schema at all (top-level properties are only
  # account/compartment/networking) and had no backing variable — the API
  # never persisted it back, causing perpetual drift on every plan.
  attributes = jsonencode({
    account = {
      id     = var.account_id
      region = var.account_region
      name   = var.account_name
    },
    compartment = {
      id   = var.compartment_id,
      name = var.compartment_name
    },
    networking = {
      domain_name : var.domain_name,
      application_domain  = var.application_domain,
      private_domain_name = var.private_domain_name
    }
  })
}
