
# Module: Azure Cloud

Creates the Nullplatform Azure cloud configuration with account metadata and DNS settings sourced from the provided hosted zones and domain.

Usage:

```
module "cloud_azure" {
  source                    = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/cloud/azure/cloud?ref=v1.0.0"
  nrn                       = var.nrn
  np_api_key                = var.np_api_key
  domain_name               = var.domain_name
  dimensions                = var.dimensions
  azure_resource_group_name = var.azure_resource_group_name
  azure_tenant_id           = var.azure_tenant_id
  azure_subscription_id     = var.azure_subscription_id

}
```


<!-- BEGIN_TF_DOCS -->


<!-- END_TF_DOCS -->