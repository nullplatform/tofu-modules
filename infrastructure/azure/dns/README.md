# Module: dns

## Description

Creates an Azure public DNS zone with configurable tags and outputs name servers for domain delegation

## Features

- Creates an Azure public DNS zone in a specified resource group
- Configures custom domain name for DNS hosting
- Supports optional tagging for resource organization
- Outputs DNS zone name servers for domain delegation
- Provides DNS zone ID and name for integration with other resources

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/dns?ref=v1.42.0"

  domain_name         = local.domain_name
  resource_group_name = module.resource_group.resource_group_name
  subscription_id     = var.subscription_id
}
```

## Using Outputs

```hcl
# dns_zone_name is used by cert_manager and external_dns modules
# No direct Terraform module reference — consumed via provider configuration.
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
| [azurerm_dns_zone.public_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to use for the DNS zone (e.g., example.com) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the DNS zone will be created | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of the Azure subscription | `string` | n/a | yes |
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
