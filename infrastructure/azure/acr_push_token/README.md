# Module: acr_push_token

## Description

Creates a push-only Azure Container Registry token with an optional expiring password for use as a CI credential

## Architecture

The module looks up the built-in `_repositories_push` scope map from an existing Azure Container Registry using the `azurerm_container_registry_scope_map` data source. It then creates an `azurerm_container_registry_token` bound to that scope map, granting push and pull access to all repositories without admin privileges. An `azurerm_container_registry_token_password` resource is attached to the token, optionally configured with an RFC 3339 expiry timestamp. The token name, password value, and token ID are surfaced as outputs for downstream consumption by CI systems or nullplatform docker-server assets.

## Features

- Creates an azurerm_container_registry_token scoped to the built-in _repositories_push scope map for least-privilege CI access
- Generates an azurerm_container_registry_token_password with optional RFC 3339 expiry for time-bounded credentials
- Exposes the token username and sensitive password as outputs for direct use in CI pipelines
- Validates password_expiry format using formatdate to enforce valid RFC 3339 timestamps
- Enables admin-user-free registry access by pairing with AKS kubelet identity for pull and this token for push

## Basic Usage

```hcl
module "acr_push_token" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/acr_push_token?ref=v8.5.0"

  containerregistry_name = "your-containerregistry-name"
  resource_group_name    = "your-resource-group-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.acr_push_token.token_id
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.81.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry_token.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_token) | resource |
| [azurerm_container_registry_token_password.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_token_password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_containerregistry_name"></a> [containerregistry\_name](#input\_containerregistry\_name) | The name of the existing Azure Container Registry the token is created in | `string` | n/a | yes |
| <a name="input_password_expiry"></a> [password\_expiry](#input\_password\_expiry) | RFC 3339 timestamp when the token password expires (e.g. 2027-01-01T00:00:00Z). Null means it never expires. Changing it regenerates the password, so the docker-server asset must be re-applied with the new value | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group of the container registry | `string` | n/a | yes |
| <a name="input_token_name"></a> [token\_name](#input\_token\_name) | The name of the ACR token. It is also the username CI logs in with | `string` | `"nullplatform-ci-push"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_password"></a> [password](#output\_password) | The token password CI logs in with |
| <a name="output_token_id"></a> [token\_id](#output\_token\_id) | The ID of the ACR token |
| <a name="output_username"></a> [username](#output\_username) | The username CI logs in with (the token name) |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "acr_push_token",
  "description": "Creates a push-only Azure Container Registry token with an optional expiring password for use as a CI credential",
  "architecture": "The module looks up the built-in `_repositories_push` scope map from an existing Azure Container Registry using the `azurerm_container_registry_scope_map` data source. It then creates an `azurerm_container_registry_token` bound to that scope map, granting push and pull access to all repositories without admin privileges. An `azurerm_container_registry_token_password` resource is attached to the token, optionally configured with an RFC 3339 expiry timestamp. The token name, password value, and token ID are surfaced as outputs for downstream consumption by CI systems or nullplatform docker-server assets.",
  "features": [
    "Creates an azurerm_container_registry_token scoped to the built-in _repositories_push scope map for least-privilege CI access",
    "Generates an azurerm_container_registry_token_password with optional RFC 3339 expiry for time-bounded credentials",
    "Exposes the token username and sensitive password as outputs for direct use in CI pipelines",
    "Validates password_expiry format using formatdate to enforce valid RFC 3339 timestamps",
    "Enables admin-user-free registry access by pairing with AKS kubelet identity for pull and this token for push"
  ],
  "inputs": [
    {
      "name": "containerregistry_name",
      "description": "The name of the existing Azure Container Registry the token is created in",
      "required": true
    },
    {
      "name": "resource_group_name",
      "description": "The name of the resource group of the container registry",
      "required": true
    },
    {
      "name": "password_expiry",
      "description": "RFC 3339 timestamp when the token password expires (e.g. 2027-01-01T00:00:00Z). Null means it never expires. Changing it regenerates the password, so the docker-server asset must be re-applied with the new value",
      "required": false
    },
    {
      "name": "token_name",
      "description": "The name of the ACR token. It is also the username CI logs in with",
      "required": false
    }
  ],
  "outputs": [
    "token_id",
    "username",
    "password"
  ],
  "hash": "a82ecccf35885c52728ba62a98b0f438"
}
END_AI_METADATA -->
