resource "nullplatform_provider_config" "azure" {
  nrn  = var.nrn
  type = "azure-configuration"


  dimensions = var.dimensions

  attributes = jsonencode({
    authentication = {},
    networking = {
      application_domain                    = true,
      domain_name                           = var.domain_name,
      public_dns_zone_name                  = var.domain_name,
      private_dns_zone_name                 = var.private_domain_name
      public_dns_zone_resource_group_name   = var.azure_resource_group_name
      private_dns_zone_resource_group_name  = var.private_dns_resource_group_name
    }
  })
}