# Module: acr

## Description

Provisions an Azure Container Registry using the AVM module with configurable SKU, admin access, zone redundancy, and retention policies

## Architecture

The module wraps the azure/avm-res-containerregistry-registry/azurerm AVM module, passing through inputs such as name, location, resource_group_name, sku, admin_enabled, zone_redundancy_enabled, and retention_policy_in_days directly into the underlying azurerm_container_registry resource. Outputs are sourced from the module's resource object rather than a data source, avoiding deferred evaluation during apply. Admin credentials are conditionally exposed as sensitive outputs only when admin_enabled is true.

## Features

- Creates an Azure Container Registry with support for Basic, Standard, and Premium SKUs
- Configures optional zone redundancy for high availability across availability zones (requires Premium SKU)
- Enables configurable untagged manifest retention policy in days (requires Premium SKU)
- Exposes registry login server FQDN as an output for downstream consumer configuration
- Conditionally outputs sensitive admin username and password only when admin user is enabled
- Supports resource tagging via a flexible map of key-value tag pairs
- Validates registry name format to enforce Azure naming constraints (5-50 lowercase alphanumeric characters)

## Basic Usage

```hcl
module "acr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/acr?ref=v8.5.0"

  containerregistry_name = "your-containerregistry-name"
  location               = "your-location"
  resource_group_name    = "your-resource-group-name"
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_containerregistry"></a> [containerregistry](#module\_containerregistry) | azure/avm-res-containerregistry-registry/azurerm | v0.4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Whether to enable the registry admin user (static username/password with full access). Set to false once AKS pulls via attach\_acr and CI pushes via acr\_push\_token. | `bool` | `true` | no |
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
| <a name="output_acr_admin_password"></a> [acr\_admin\_password](#output\_acr\_admin\_password) | The admin password of the ACR. Null when admin\_enabled is false. |
| <a name="output_acr_admin_username"></a> [acr\_admin\_username](#output\_acr\_admin\_username) | The admin username of the ACR. Null when admin\_enabled is false. |
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | The ID of the Azure Container Registry |
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | The FQDN of the ACR login server |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "acr",
  "description": "Provisions an Azure Container Registry using the AVM module with configurable SKU, admin access, zone redundancy, and retention policies",
  "architecture": "The module wraps the azure/avm-res-containerregistry-registry/azurerm AVM module, passing through inputs such as name, location, resource_group_name, sku, admin_enabled, zone_redundancy_enabled, and retention_policy_in_days directly into the underlying azurerm_container_registry resource. Outputs are sourced from the module's resource object rather than a data source, avoiding deferred evaluation during apply. Admin credentials are conditionally exposed as sensitive outputs only when admin_enabled is true.",
  "features": [
    "Creates an Azure Container Registry with support for Basic, Standard, and Premium SKUs",
    "Configures optional zone redundancy for high availability across availability zones (requires Premium SKU)",
    "Enables configurable untagged manifest retention policy in days (requires Premium SKU)",
    "Exposes registry login server FQDN as an output for downstream consumer configuration",
    "Conditionally outputs sensitive admin username and password only when admin user is enabled",
    "Supports resource tagging via a flexible map of key-value tag pairs",
    "Validates registry name format to enforce Azure naming constraints (5-50 lowercase alphanumeric characters)"
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
      "name": "admin_enabled",
      "description": "Whether to enable the registry admin user (static username/password with full access). Set to false once AKS pulls via attach_acr and CI pushes via acr_push_token.",
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
  "hash": "586e409898131756adebfb6e2c36e2e5"
}
END_AI_METADATA -->
