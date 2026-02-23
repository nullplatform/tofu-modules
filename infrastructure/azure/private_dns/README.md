# Module: private_dns

## Description

Creates an Azure Private DNS Zone with configurable virtual network links for private endpoint DNS resolution

## Features

- Creates an Azure Private DNS Zone with a specified domain name
- Supports linking multiple virtual networks to the private DNS zone
- Configures registration settings per virtual network link for VM auto-registration
- Manages virtual network links with customizable names based on index
- Applies tags to the private DNS zone for resource organization
- Outputs private DNS zone details and virtual network link IDs for reference

## Basic Usage

```hcl
module "private_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/private_dns?ref=v1.36.0"

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
