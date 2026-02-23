# Module: cloud

## Description

Configures Azure networking and DNS settings as a provider configuration in nullplatform

## Features

- Creates a nullplatform provider configuration for Azure
- Configures public and private DNS zone settings
- Manages application domain settings
- Supports custom dimensions for resource organization
- Links Azure resource groups for DNS management
- Provides flexible domain name configuration

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/azure/cloud?ref=v1.35.0"

  azure_resource_group_name       = "your-azure-resource-group-name"
  nrn                             = "your-nrn"
  private_dns_resource_group_name = "your-private-dns-resource-group-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.cloud.id
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
| <a name="input_application_domain"></a> [application\_domain](#input\_application\_domain) | Apply application domain or not | `bool` | `false` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Your Azure resource group name | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Define dimensions. For more information, see https://docs.nullplatform.com/docs/dimensions | `map(any)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to be used | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The NRN of your nullplatform account | `string` | n/a | yes |
| <a name="input_private_dns_resource_group_name"></a> [private\_dns\_resource\_group\_name](#input\_private\_dns\_resource\_group\_name) | Azure resource group name for the DNS private | `string` | n/a | yes |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | The private domain name to be used | `string` | `""` | no |
<!-- END_TF_DOCS -->
