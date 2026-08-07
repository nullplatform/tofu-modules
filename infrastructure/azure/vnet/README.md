# Module: vnet

## Description

Creates an Azure Virtual Network with configurable subnets using the Azure Verified Module for network virtual networks

## Architecture

The module wraps the azure/avm-res-network-virtualnetwork/azurerm AVM module, passing address_space, name, location, and tags directly into it while constructing the parent_id from the subscription_id and resource_group_name inputs. The subnets_definition map is forwarded to the AVM module's subnets argument, which internally provisions azurerm_subnet resources with optional route table associations. Outputs derive from the AVM module's resource_id and name attributes, with subnet_ids computed by interpolating subnet names against the virtual network resource ID.

## Features

- Creates an Azure Virtual Network with one or more CIDR address spaces
- Provisions multiple subnets with configurable address prefixes via a flexible map input
- Supports optional route table association per subnet to preserve existing routing configurations
- Outputs a computed map of subnet names to their full Azure resource IDs
- Applies resource tags to all virtual network resources

## Basic Usage

```hcl
module "vnet" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/vnet?ref=v6.11.0"

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
| <a name="input_subnets_definition"></a> [subnets\_definition](#input\_subnets\_definition) | A map of subnets to create within the virtual network. Each subnet requires<br/>a name and address\_prefixes, and may set route\_table to associate an<br/>existing route table. | <pre>map(object({<br/>    name             = string<br/>    address_prefixes = list(string)<br/><br/>    # The AVM submodule accepts this and always renders the field, so leaving it<br/>    # out is an explicit `routeTable: null` -- i.e. a detach -- not an omission.<br/>    # On an AKS kubenet subnet that means every plan proposes to strip the route<br/>    # table AKS attached, which is why `aks_route_table` has to keep putting it<br/>    # back. Declaring it here lets the subnet own what it actually has.<br/>    route_table = optional(object({<br/>      id = string<br/>    }))<br/>  }))</pre> | n/a | yes |
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
  "description": "Creates an Azure Virtual Network with configurable subnets using the Azure Verified Module for network virtual networks",
  "architecture": "The module wraps the azure/avm-res-network-virtualnetwork/azurerm AVM module, passing address_space, name, location, and tags directly into it while constructing the parent_id from the subscription_id and resource_group_name inputs. The subnets_definition map is forwarded to the AVM module's subnets argument, which internally provisions azurerm_subnet resources with optional route table associations. Outputs derive from the AVM module's resource_id and name attributes, with subnet_ids computed by interpolating subnet names against the virtual network resource ID.",
  "features": [
    "Creates an Azure Virtual Network with one or more CIDR address spaces",
    "Provisions multiple subnets with configurable address prefixes via a flexible map input",
    "Supports optional route table association per subnet to preserve existing routing configurations",
    "Outputs a computed map of subnet names to their full Azure resource IDs",
    "Applies resource tags to all virtual network resources"
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
      "description": "",
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
  "hash": "6e0c66f2c0f455a2b357a8d2e0d56ae8"
}
END_AI_METADATA -->
