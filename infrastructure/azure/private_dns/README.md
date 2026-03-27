# Module: private_dns

## Description

Creates a private DNS zone in Azure with optional virtual network links and tags

## Architecture

This module creates an azurerm_private_dns_zone resource and optionally multiple azurerm_private_dns_zone_virtual_network_link resources, which are connected to the private DNS zone. The virtual network links are created based on the virtual_network_links input variable, which is a list of objects containing the virtual network ID and an optional registration enabled flag. The module also supports assigning tags to the private DNS zone using the tags input variable. The module outputs the name, ID, and virtual network link IDs of the created resources.

## Features

- Creates a private DNS zone with a specified domain name
- Configures virtual network links to the private DNS zone with optional registration enabled
- Supports assigning tags to the private DNS zone

## Basic Usage

```hcl
module "private_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/private_dns?ref=v1.48.1"

  domain_name           = "your-domain-name"
  resource_group_name   = "your-resource-group-name"
  subscription_id       = "your-subscription-id"
  virtual_network_links = "your-virtual-network-links"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.private_dns.private_dns_zone_name
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to use for the private DNS zone (e.g., privatelink.database.windows.net) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the private DNS zone will be created | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of the Azure subscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the private DNS zone | `map(string)` | `{}` | no |
| <a name="input_virtual_network_links"></a> [virtual\_network\_links](#input\_virtual\_network\_links) | List of virtual networks to link to the private DNS zone. Each object requires vnet\_id and optionally registration\_enabled (false for AKS/Private Link, true for VMs auto-registration) | <pre>list(object({<br/>    vnet_id              = string<br/>    registration_enabled = optional(bool, false)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | The ID of the private DNS zone |
| <a name="output_private_dns_zone_name"></a> [private\_dns\_zone\_name](#output\_private\_dns\_zone\_name) | The name of the created private DNS zone |
| <a name="output_virtual_network_link_ids"></a> [virtual\_network\_link\_ids](#output\_virtual\_network\_link\_ids) | The IDs of the virtual network links |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "private_dns",
  "description": "Creates a private DNS zone in Azure with optional virtual network links and tags",
  "architecture": "This module creates an azurerm_private_dns_zone resource and optionally multiple azurerm_private_dns_zone_virtual_network_link resources, which are connected to the private DNS zone. The virtual network links are created based on the virtual_network_links input variable, which is a list of objects containing the virtual network ID and an optional registration enabled flag. The module also supports assigning tags to the private DNS zone using the tags input variable. The module outputs the name, ID, and virtual network link IDs of the created resources.",
  "features": [
    "Creates a private DNS zone with a specified domain name",
    "Configures virtual network links to the private DNS zone with optional registration enabled",
    "Supports assigning tags to the private DNS zone"
  ],
  "inputs": [
    {
      "name": "resource_group_name",
      "description": "The name of the resource group where the private DNS zone will be created",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "The domain name to use for the private DNS zone (e.g., privatelink.database.windows.net)",
      "required": true
    },
    {
      "name": "subscription_id",
      "description": "The ID of the Azure subscription",
      "required": true
    },
    {
      "name": "virtual_network_links",
      "description": "List of virtual networks to link to the private DNS zone. Each object requires vnet_id and optionally registration_enabled (false for AKS/Private Link, true for VMs auto-registration)",
      "required": true
    },
    {
      "name": "tags",
      "description": "A mapping of tags to assign to the private DNS zone",
      "required": false
    }
  ],
  "outputs": [
    "private_dns_zone_name",
    "private_dns_zone_id",
    "virtual_network_link_ids"
  ],
  "hash": "9ed5400246581dbf42bec26262b81e0c"
}
END_AI_METADATA -->
