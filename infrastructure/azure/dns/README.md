# Module: dns

## Description

Creates an Azure DNS zone with a specified domain name in a given resource group

## Architecture

This module creates an azurerm_dns_zone resource and configures it with the provided domain name and resource group name. The azurerm_dns_zone resource is then used to generate various output values, including the DNS zone name, ID, and name servers. The module also accepts optional tags that can be applied to the DNS zone. The internal data flow involves passing the input variables to the azurerm_dns_zone resource and then extracting the relevant output values from the created resource.

## Features

- Creates Azure DNS zone with specified domain name
- Configures DNS zone with provided resource group name
- Generates output values for DNS zone name, ID, and name servers

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/dns?ref=v6.13.1"

  domain_name         = "your-domain-name"
  resource_group_name = "your-resource-group-name"
  subscription_id     = "your-subscription-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dns.dns_zone_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.68.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_dns_zone.public_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to use for the DNS zone (e.g., example.com) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the DNS zone will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the DNS zone | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | The ID of the DNS zone |
| <a name="output_dns_zone_name"></a> [dns\_zone\_name](#output\_dns\_zone\_name) | The name of the created DNS zone |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | The list of name servers for the DNS zone |
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | The ID of the created private DNS zone |
| <a name="output_private_dns_zone_name"></a> [private\_dns\_zone\_name](#output\_private\_dns\_zone\_name) | The name of the created private DNS zone |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "dns",
  "description": "Creates an Azure DNS zone with a specified domain name in a given resource group",
  "architecture": "This module creates an azurerm_dns_zone resource and configures it with the provided domain name and resource group name. The azurerm_dns_zone resource is then used to generate various output values, including the DNS zone name, ID, and name servers. The module also accepts optional tags that can be applied to the DNS zone. The internal data flow involves passing the input variables to the azurerm_dns_zone resource and then extracting the relevant output values from the created resource.",
  "features": [
    "Creates Azure DNS zone with specified domain name",
    "Configures DNS zone with provided resource group name",
    "Generates output values for DNS zone name, ID, and name servers"
  ],
  "inputs": [
    {
      "name": "resource_group_name",
      "description": "The name of the resource group where the DNS zone will be created",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "The domain name to use for the DNS zone (e.g., example.com)",
      "required": true
    },
    {
      "name": "subscription_id",
      "description": "The ID of the Azure subscription",
      "required": true
    },
    {
      "name": "tags",
      "description": "A mapping of tags to assign to the DNS zone",
      "required": false
    }
  ],
  "outputs": [
    "dns_zone_name",
    "dns_zone_id",
    "private_dns_zone_name",
    "private_dns_zone_id",
    "name_servers"
  ],
  "hash": "cc9e028f7cd35862044d66cf477be8ae"
}
END_AI_METADATA -->
