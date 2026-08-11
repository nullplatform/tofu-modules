# Module: aks_route_table

## Description

Attaches the AKS-managed kubenet route table to a specified subnet by discovering the route table from the node resource group and updating the subnet via the AzAPI provider

## Architecture

The module uses an azurerm_resources data source to discover the AKS-managed route table within the node resource group by filtering for Microsoft.Network/routeTables. A terraform_data resource tracks the subnet ID and route table ID as triggers to detect attachment drift. The azapi_update_resource resource performs a PATCH against the Microsoft.Network/virtualNetworks/subnets API to set the routeTable property on the target subnet, and is replaced whenever the terraform_data trigger detects a change in either input.

## Features

- Discovers the AKS-managed route table automatically from the node resource group using azurerm_resources data lookup
- Attaches the discovered route table to a specified subnet via azapi_update_resource targeting the Microsoft.Network/virtualNetworks/subnets API
- Prevents perpetual re-attachment by keying the terraform_data trigger on the stable subnet and route table IDs rather than timestamps
- Outputs the resource ID of the AKS-managed route table for use by downstream modules

## Basic Usage

```hcl
module "aks_route_table" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/aks_route_table?ref=v7.0.3"

  node_resource_group = "your-node-resource-group"
  subnet_id           = "your-subnet-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.aks_route_table.route_table_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.9.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.73.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_update_resource.aks_subnet_route_table](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/update_resource) | resource |
| [terraform_data.trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | The resource group where AKS creates its managed node resources (including the kubenet route table) | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The resource ID of the AKS node subnet to keep the route table attached to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | The resource ID of the AKS-managed route table |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "aks_route_table",
  "description": "Attaches the AKS-managed kubenet route table to a specified subnet by discovering the route table from the node resource group and updating the subnet via the AzAPI provider",
  "architecture": "The module uses an azurerm_resources data source to discover the AKS-managed route table within the node resource group by filtering for Microsoft.Network/routeTables. A terraform_data resource tracks the subnet ID and route table ID as triggers to detect attachment drift. The azapi_update_resource resource performs a PATCH against the Microsoft.Network/virtualNetworks/subnets API to set the routeTable property on the target subnet, and is replaced whenever the terraform_data trigger detects a change in either input.",
  "features": [
    "Discovers the AKS-managed route table automatically from the node resource group using azurerm_resources data lookup",
    "Attaches the discovered route table to a specified subnet via azapi_update_resource targeting the Microsoft.Network/virtualNetworks/subnets API",
    "Prevents perpetual re-attachment by keying the terraform_data trigger on the stable subnet and route table IDs rather than timestamps",
    "Outputs the resource ID of the AKS-managed route table for use by downstream modules"
  ],
  "inputs": [
    {
      "name": "node_resource_group",
      "description": "The resource group where AKS creates its managed node resources (including the kubenet route table)",
      "required": true
    },
    {
      "name": "subnet_id",
      "description": "The resource ID of the AKS node subnet to keep the route table attached to",
      "required": true
    }
  ],
  "outputs": [
    "route_table_id"
  ],
  "hash": "ccccbed34bb0eb0f08265ac7d7a9985a"
}
END_AI_METADATA -->
