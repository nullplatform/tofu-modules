# Module: acr

## Description

This module creates an Azure Container Registry with a specified name and configuration

## Architecture

The module uses the azurerm_container_registry resource to create the container registry, and the data.azurerm_container_registry data source to retrieve the registry's details. The module also uses the module.containerregistry module to create the registry. The inputs flow into the resources through variables, and the outputs are exposed through the output.tf file. The registry is created in the specified location and resource group, with the specified SKU and configuration.

## Features

- Creates an Azure Container Registry with a specified name and configuration
- Configures the registry with a specified SKU and zone redundancy
- Supports retention policies for untagged manifests

## Basic Usage

```hcl
module "acr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/acr?ref=v6.7.0"

  containerregistry_name = "your-containerregistry-name"
  location               = "your-location"
  resource_group_name    = "your-resource-group-name"
  subscription_id        = "your-subscription-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.acr.acr_id
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.68.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_containerregistry"></a> [containerregistry](#module\_containerregistry) | azure/avm-res-containerregistry-registry/azurerm | v0.4.0 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_containerregistry_name"></a> [containerregistry\_name](#input\_containerregistry\_name) | The name of the container registry (must be globally unique, lowercase alphanumeric only, 5-50 characters) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the container registry will be created (e.g., eastus, westus2) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the container registry will be created | `string` | n/a | yes |
| <a name="input_retention_policy_in_days"></a> [retention\_policy\_in\_days](#input\_retention\_policy\_in\_days) | The number of days to retain untagged manifests (requires Premium SKU) | `number` | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of the container registry (Basic, Standard, Premium) | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the container registry | `map(string)` | `{}` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Whether to enable zone redundancy for the container registry (requires Premium SKU) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_admin_password"></a> [acr\_admin\_password](#output\_acr\_admin\_password) | The admin password of the ACR |
| <a name="output_acr_admin_username"></a> [acr\_admin\_username](#output\_acr\_admin\_username) | The admin username of the ACR |
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | The ID of the Azure Container Registry |
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | The FQDN of the ACR login server |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "acr",
  "description": "This module creates an Azure Container Registry with a specified name and configuration",
  "architecture": "The module uses the azurerm_container_registry resource to create the container registry, and the data.azurerm_container_registry data source to retrieve the registry's details. The module also uses the module.containerregistry module to create the registry. The inputs flow into the resources through variables, and the outputs are exposed through the output.tf file. The registry is created in the specified location and resource group, with the specified SKU and configuration.",
  "features": [
    "Creates an Azure Container Registry with a specified name and configuration",
    "Configures the registry with a specified SKU and zone redundancy",
    "Supports retention policies for untagged manifests"
  ],
  "inputs": [
    {
      "name": "location",
      "description": "The Azure region where the container registry will be created (e.g., eastus, westus2)",
      "required": true
    },
    {
      "name": "resource_group_name",
      "description": "The name of the resource group where the container registry will be created",
      "required": true
    },
    {
      "name": "subscription_id",
      "description": "The ID of the Azure subscription",
      "required": true
    },
    {
      "name": "containerregistry_name",
      "description": "The name of the container registry (must be globally unique, lowercase alphanumeric only, 5-50 characters)",
      "required": true
    },
    {
      "name": "sku",
      "description": "The SKU of the container registry (Basic, Standard, Premium)",
      "required": false
    },
    {
      "name": "zone_redundancy_enabled",
      "description": "Whether to enable zone redundancy for the container registry (requires Premium SKU)",
      "required": false
    },
    {
      "name": "retention_policy_in_days",
      "description": "The number of days to retain untagged manifests (requires Premium SKU)",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of tags to assign to the container registry",
      "required": false
    }
  ],
  "outputs": [
    "acr_id",
    "acr_login_server",
    "acr_admin_username",
    "acr_admin_password"
  ],
  "hash": "54e9b4f479061680b81b29246e7f6bc5"
}
END_AI_METADATA -->
