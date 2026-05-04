# Module: cloud

## Description

Configures Azure networking settings for a Nullplatform provider

## Architecture

Creates a nullplatform_provider_config resource of type azure-configuration that sets up networking attributes including DNS zones and resource groups. The module maps input variables like domain_name, azure_resource_group_name, and private_dns_resource_group_name into the attributes block of the provider config. The nullplatform_provider_config resource integrates with Nullplatform's infrastructure management system to apply Azure-specific networking configurations.

## Features

- Configures public and private DNS zone names for Azure
- Maps Azure resource groups to DNS zones
- Supports custom application domain configuration
- Allows dimension tagging for resource organization

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/azure/cloud?ref=v2.0.1"

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

<!-- BEGIN_AI_METADATA
{
  "name": "cloud",
  "description": "Configures Azure networking settings for a Nullplatform provider",
  "architecture": "Creates a nullplatform_provider_config resource of type azure-configuration that sets up networking attributes including DNS zones and resource groups. The module maps input variables like domain_name, azure_resource_group_name, and private_dns_resource_group_name into the attributes block of the provider config. The nullplatform_provider_config resource integrates with Nullplatform's infrastructure management system to apply Azure-specific networking configurations.",
  "features": [
    "Configures public and private DNS zone names for Azure",
    "Maps Azure resource groups to DNS zones",
    "Supports custom application domain configuration",
    "Allows dimension tagging for resource organization"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "The NRN of your nullplatform account",
      "required": true
    },
    {
      "name": "azure_resource_group_name",
      "description": "Your Azure resource group name",
      "required": true
    },
    {
      "name": "private_dns_resource_group_name",
      "description": "Azure resource group name for the DNS private",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "The domain name to be used",
      "required": false
    },
    {
      "name": "application_domain",
      "description": "Apply application domain or not",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Define dimensions. For more information, see https://docs.nullplatform.com/docs/dimensions",
      "required": false
    },
    {
      "name": "private_domain_name",
      "description": "The private domain name to be used",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "1038ba6fe7ba85cfa18ce2965b818679"
}
END_AI_METADATA -->
