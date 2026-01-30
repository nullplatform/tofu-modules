resource "nullplatform_provider_config" "oci" {
  nrn  = var.nrn
  type = "oci"


  dimensions = var.dimensions

  attributes = jsonencode({
    authentication = {},
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
  lifecycle {
    ignore_changes = [attributes]
  }
}
