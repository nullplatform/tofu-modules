
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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.azure](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Your azure reource group name | `string` | n/a | yes |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Your azure suscription id | `string` | n/a | yes |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Your azure tenant id | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Define to dimensions, for more information https://docs.nullplatform.com/docs/dimensions | `map(any)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to be used | `string` | `""` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Your nullplatform api key(developer.member, ops and secops permissions) | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nrn of your nullplatform account | `string` | n/a | yes |
<!-- END_TF_DOCS -->