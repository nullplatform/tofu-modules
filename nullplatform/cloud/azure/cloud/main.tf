resource "nullplatform_provider_config" "azure" {
  nrn  = var.nrn
  type = "azure-configuration"


  dimensions = var.dimensions

  attributes = jsonencode({
    authentication = {
      for k, v in {
        client_id       = var.client_id
        client_secret   = var.client_secret
        subscription_id = var.subscription_id
        tenant_id       = var.tenant_id
      } : k => v if v != null
    },
    networking = {
      application_domain                   = var.application_domain,
      domain_name                          = var.domain_name,
      public_dns_zone_name                 = var.domain_name,
      private_dns_zone_name                = var.private_domain_name
      public_dns_zone_resource_group_name  = var.azure_resource_group_name
      private_dns_zone_resource_group_name = var.private_dns_resource_group_name
    }
  })
  lifecycle {
    precondition {
      condition = (
        (var.client_id == null) == (var.client_secret == null) &&
        (var.client_id == null) == (var.subscription_id == null) &&
        (var.client_id == null) == (var.tenant_id == null)
      )
      error_message = "Authentication credentials must all be set or all be null (client_id, client_secret, subscription_id, tenant_id)."
    }
    ignore_changes = [attributes]
  }
}
