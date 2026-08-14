# Module: aks_route_table

## Description

Attaches the AKS-managed kubenet route table to a specified subnet by discovering the route table from the node resource group and updating the subnet via the Azure API

## Architecture

The module uses an azurerm_resources data source to discover the AKS-managed route table within the node resource group by filtering for Microsoft.Network/routeTables resources. A terraform_data trigger resource tracks the subnet ID and route table ID pair to detect real attachment changes without drifting on timestamps. An azapi_update_resource targets the Microsoft.Network/virtualNetworks/subnets resource at the provided subnet_id and patches its routeTable property to point to the discovered route table ID. The replace_triggered_by lifecycle hook ensures the subnet update is re-applied whenever the trigger detects a change in the attachment pairing.

## Features

- Discovers AKS-managed kubenet route table automatically from the node resource group using azurerm_resources data source
- Attaches the discovered route table to the specified AKS node subnet via azapi_update_resource with the 2024-01-01 API version
- Implements stable change detection using a terraform_data trigger keyed on subnet and route table IDs to prevent unnecessary replacements
- Outputs the discovered route table resource ID for downstream module consumption

## Basic Usage

```hcl
module "aks_route_table" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/aks_route_table?ref=v6.15.0"

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
  "description": "Attaches the AKS-managed kubenet route table to a specified subnet by discovering the route table from the node resource group and updating the subnet via the Azure API",
  "architecture": "The module uses an azurerm_resources data source to discover the AKS-managed route table within the node resource group by filtering for Microsoft.Network/routeTables resources. A terraform_data trigger resource tracks the subnet ID and route table ID pair to detect real attachment changes without drifting on timestamps. An azapi_update_resource targets the Microsoft.Network/virtualNetworks/subnets resource at the provided subnet_id and patches its routeTable property to point to the discovered route table ID. The replace_triggered_by lifecycle hook ensures the subnet update is re-applied whenever the trigger detects a change in the attachment pairing.",
  "features": [
    "Discovers AKS-managed kubenet route table automatically from the node resource group using azurerm_resources data source",
    "Attaches the discovered route table to the specified AKS node subnet via azapi_update_resource with the 2024-01-01 API version",
    "Implements stable change detection using a terraform_data trigger keyed on subnet and route table IDs to prevent unnecessary replacements",
    "Outputs the discovered route table resource ID for downstream module consumption"
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
