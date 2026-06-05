resource "nullplatform_provider_config" "azure" {
  nrn  = var.nrn
  type = "azure-configuration"


  dimensions = var.dimensions

  attributes = jsonencode({
    authentication = {
      client_id       = var.client_id
      client_secret   = var.client_secret
      subscription_id = var.subscription_id
      tenant_id       = var.tenant_id
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
}
