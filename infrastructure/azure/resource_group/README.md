# Module: Azure Resource Group 

This module creates an Azure resource group.

## Features

- Creates an Azure resource group in the specified location  
- Supports configurable tags for resource management  
- Outputs the resource group name and location for use in other modules  

## Usage

### Basic Example

```hcl
module "resource_group" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/resource_group?ref=v1.5.0"
  resource_group_name = var.resource_group_name
  location            = var.location
  subscription_id     = var.subscription_id
}
```

## Important notes

- **Resource group name**: Must be unique within your Azure subscription
- **Location**: Cannot be changed after creation; changing it requires recreating the resource group
- **Dependencies**: This module is typically created first and referenced by other Azure resources


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
| [azurerm_resource_group.nullplatform_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/4.41.0/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the resource group should be created (e.g., eastus, westus2) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to create | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of your Azure subscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource group | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The location of the created resource group |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the created resource group |
<!-- END_TF_DOCS -->