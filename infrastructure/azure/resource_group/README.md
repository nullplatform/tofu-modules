# Module: resource_group

## Description

Creates an Azure resource group with specified name and location

## Architecture

This module creates an azurerm_resource_group resource and outputs its name and location. The resource group is created with the specified name and location, and any provided tags are applied. The module uses the azurerm_resource_group Terraform resource type to create the resource group. The inputs for the resource group name, location, and tags flow into the azurerm_resource_group resource, and the outputs are exposed as resource_group_name and resource_group_location.

## Features

- Creates Azure resource group with custom name
- Configures resource group with specified location
- Supports custom tags for resource group

## Basic Usage

```hcl
module "resource_group" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/resource_group?ref=v1.53.0"

  location            = "your-location"
  resource_group_name = "your-resource-group-name"
  subscription_id     = "your-subscription-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.resource_group.resource_group_name
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
| [azurerm_resource_group.nullplatform_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

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

<!-- BEGIN_AI_METADATA
{
  "name": "resource_group",
  "description": "Creates an Azure resource group with specified name and location",
  "architecture": "This module creates an azurerm_resource_group resource and outputs its name and location. The resource group is created with the specified name and location, and any provided tags are applied. The module uses the azurerm_resource_group Terraform resource type to create the resource group. The inputs for the resource group name, location, and tags flow into the azurerm_resource_group resource, and the outputs are exposed as resource_group_name and resource_group_location.",
  "features": [
    "Creates Azure resource group with custom name",
    "Configures resource group with specified location",
    "Supports custom tags for resource group"
  ],
  "inputs": [
    {
      "name": "resource_group_name",
      "description": "The name of the resource group to create",
      "required": true
    },
    {
      "name": "location",
      "description": "The Azure region where the resource group should be created (e.g., eastus, westus2)",
      "required": true
    },
    {
      "name": "subscription_id",
      "description": "The ID of your Azure subscription",
      "required": true
    },
    {
      "name": "tags",
      "description": "A mapping of tags to assign to the resource group",
      "required": false
    }
  ],
  "outputs": [
    "resource_group_name",
    "resource_group_location"
  ],
  "hash": "76f7d8d9701e695b55ef2e2b52c13100"
}
END_AI_METADATA -->
