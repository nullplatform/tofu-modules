# Module: vnet

## Description

Creates an Azure Virtual Network with customizable subnets using the Azure Verified Module for network virtual networks

## Features

- Creates an Azure Virtual Network with configurable address space
- Supports multiple subnet definitions with custom address prefixes
- Manages virtual network resources within a specified resource group and location
- Outputs virtual network ID, name, and subnet resource IDs for reference
- Applies custom tags to virtual network resources for organization
- Leverages Azure Verified Module (AVM) for standardized virtual network deployment

## Basic Usage

```hcl
module "vnet" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/vnet?ref=v1.36.0"

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
