# Module: aks_route_table

## Description

Associates the AKS-managed kubenet route table with a specified subnet by discovering and attaching it on every apply

## Architecture

The module uses an azurerm_resources data source to discover the route table created by AKS in the node resource group. A terraform_data resource with a timestamp trigger forces re-evaluation on every apply. The azapi_update_resource resource then patches the subnet identified by subnet_id using the Azure Network API to attach the discovered route table, with its lifecycle tied to the terraform_data trigger.

## Features

- Discovers the AKS-managed kubenet route table dynamically from the node resource group using azurerm_resources
- Patches the target subnet via azapi_update_resource to associate the route table on every Terraform apply
- Forces re-association on every apply using a timestamp-based terraform_data trigger to prevent drift
- Outputs the resource ID of the discovered AKS-managed route table for downstream use

## Basic Usage

```hcl
module "aks_route_table" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/aks_route_table?ref=v3.5.2"

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
  "description": "Associates the AKS-managed kubenet route table with a specified subnet by discovering and attaching it on every apply",
  "architecture": "The module uses an azurerm_resources data source to discover the route table created by AKS in the node resource group. A terraform_data resource with a timestamp trigger forces re-evaluation on every apply. The azapi_update_resource resource then patches the subnet identified by subnet_id using the Azure Network API to attach the discovered route table, with its lifecycle tied to the terraform_data trigger.",
  "features": [
    "Discovers the AKS-managed kubenet route table dynamically from the node resource group using azurerm_resources",
    "Patches the target subnet via azapi_update_resource to associate the route table on every Terraform apply",
    "Forces re-association on every apply using a timestamp-based terraform_data trigger to prevent drift",
    "Outputs the resource ID of the discovered AKS-managed route table for downstream use"
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
  "hash": "0bfb8f0027ba28042ae5c0ecda261756"
}
END_AI_METADATA -->
