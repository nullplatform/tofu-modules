# Module: Azure Private DNS Zone

This module creates a private DNS zone in Azure with optional virtual network links.

## Features

- Creates an Azure private DNS zone
- Supports linking to multiple virtual networks
- Optional auto-registration of VM DNS records
- Supports configurable tags for resource management

## Usage

### Basic Example

```hcl
module "private_dns" {
  source          = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/private_dns?ref=v1.x.x"
  domain_name     = "privatelink.database.windows.net"
  resource_group  = module.resource_group.resource_group_name
  subscription_id = var.subscription_id
}
```

### With Virtual Network Links

```hcl
module "private_dns" {
  source          = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/private_dns?ref=v1.x.x"
  domain_name     = "private.example.com"
  resource_group  = module.resource_group.resource_group_name
  subscription_id = var.subscription_id

  virtual_network_links = [
    {
      vnet_id              = module.vnet.vnet_id
      registration_enabled = true
    }
  ]
}
```

## Important notes

- **Domain name**: Can be any valid DNS domain name for private resolution
- **Virtual network links**: Required for DNS resolution within VNets
- **Auto-registration**: When `registration_enabled = true`, VM records are automatically created

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =4.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =4.41.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/4.41.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/4.41.0/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to use for the private DNS zone (e.g., privatelink.database.windows.net) | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group where the private DNS zone will be created | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of the Azure subscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the private DNS zone | `map(string)` | `{}` | no |
| <a name="input_virtual_network_links"></a> [virtual\_network\_links](#input\_virtual\_network\_links) | List of virtual networks to link to the private DNS zone. Each object requires vnet\_id and optionally registration\_enabled for auto-registration of VM records | <pre>list(object({<br/>    vnet_id              = string<br/>    registration_enabled = optional(bool, false)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | The ID of the private DNS zone |
| <a name="output_private_dns_zone_name"></a> [private\_dns\_zone\_name](#output\_private\_dns\_zone\_name) | The name of the created private DNS zone |
| <a name="output_virtual_network_link_ids"></a> [virtual\_network\_link\_ids](#output\_virtual\_network\_link\_ids) | The IDs of the virtual network links |
<!-- END_TF_DOCS -->
