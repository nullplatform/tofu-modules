# Module: vnet

## Description

Creates an Azure virtual network with specified address space and subnets

## Architecture

This module creates an Azure virtual network using the azurerm provider and configures it with the specified address space and subnets. The virtual network is created in the specified resource group and location. The module uses the avm_res_network_virtualnetwork module from the azure registry to create the virtual network and its subnets. The module also outputs the resource ID of the virtual network, its name, and a map of subnet names to their resource IDs.

## Features

- Creates Azure virtual network with specified address space
- Configures subnets within the virtual network
- Supports custom tagging of virtual network resources

## Basic Usage

```hcl
module "vnet" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/vnet?ref=v6.7.2"

  address_space       = "your-address-space"
  location            = "your-location"
  resource_group_name = "your-resource-group-name"
  subnets_definition  = "your-subnets-definition"
  subscription_id     = "your-subscription-id"
  vnet_name           = "your-vnet-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.vnet.vnet_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_avm_res_network_virtualnetwork"></a> [avm\_res\_network\_virtualnetwork](#module\_avm\_res\_network\_virtualnetwork) | azure/avm-res-network-virtualnetwork/azurerm | 0.17.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space (CIDR blocks) for the virtual network (e.g., ["10.0.0.0/16"]) | `set(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the virtual network will be created (e.g., eastus, westus2) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the virtual network will be created | `string` | n/a | yes |
| <a name="input_subnets_definition"></a> [subnets\_definition](#input\_subnets\_definition) | A map of subnets to create within the virtual network. Each subnet requires a name and address\_prefixes. | <pre>map(object({<br/>    name             = string<br/>    address_prefixes = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of the Azure subscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the virtual network resources | `map(string)` | `{}` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the virtual network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet names to their resource IDs |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The resource ID of the virtual network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the virtual network |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "vnet",
  "description": "Creates an Azure virtual network with specified address space and subnets",
  "architecture": "This module creates an Azure virtual network using the azurerm provider and configures it with the specified address space and subnets. The virtual network is created in the specified resource group and location. The module uses the avm_res_network_virtualnetwork module from the azure registry to create the virtual network and its subnets. The module also outputs the resource ID of the virtual network, its name, and a map of subnet names to their resource IDs.",
  "features": [
    "Creates Azure virtual network with specified address space",
    "Configures subnets within the virtual network",
    "Supports custom tagging of virtual network resources"
  ],
  "inputs": [
    {
      "name": "vnet_name",
      "description": "The name of the virtual network",
      "required": true
    },
    {
      "name": "resource_group_name",
      "description": "The name of the resource group where the virtual network will be created",
      "required": true
    },
    {
      "name": "location",
      "description": "The Azure region where the virtual network will be created (e.g., eastus, westus2)",
      "required": true
    },
    {
      "name": "address_space",
      "description": "The address space (CIDR blocks) for the virtual network (e.g., [\\",
      "required": true
    },
    {
      "name": "subnets_definition",
      "description": "A map of subnets to create within the virtual network. Each subnet requires a name and address_prefixes.",
      "required": true
    },
    {
      "name": "subscription_id",
      "description": "The ID of the Azure subscription",
      "required": true
    },
    {
      "name": "tags",
      "description": "A mapping of tags to assign to the virtual network resources",
      "required": false
    }
  ],
  "outputs": [
    "vnet_id",
    "vnet_name",
    "subnet_ids"
  ],
  "hash": "fd524b5a584382c1be860e9b6871644c"
}
END_AI_METADATA -->
