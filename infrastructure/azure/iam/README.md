# Module: iam

## Description

Creates an Azure user-assigned managed identity with federated credentials for Kubernetes workload identity and assigns an Azure RBAC role

## Architecture

The module creates an azurerm_user_assigned_identity resource in the specified resource group and location. It then establishes an azurerm_federated_identity_credential linking the managed identity to a Kubernetes service account via OIDC issuer URL, enabling workload identity federation. Finally, it creates an azurerm_role_assignment granting the managed identity's principal the specified Azure RBAC role at the given scope.

## Features

- Creates Azure user-assigned managed identity in specified resource group and location
- Configures federated identity credential with OIDC issuer for Kubernetes service account authentication
- Establishes workload identity federation using api://AzureADTokenExchange audience
- Assigns Azure RBAC role to the managed identity at specified scope
- Outputs client ID, principal ID, and resource ID for integration with Kubernetes resources
- Supports custom tagging for resource organization and cost tracking

## Basic Usage

```hcl
module "iam" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/iam?ref=v2.3.1"

  location             = "your-location"
  name                 = "your-name"
  namespace            = "your-namespace"
  oidc_issuer_url      = "your-oidc-issuer-url"
  resource_group_name  = "your-resource-group-name"
  role_definition_name = "your-role-definition-name"
  scope                = "your-scope"
  service_account_name = "your-service-account-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.iam.client_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the managed identity will be created | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the user-assigned managed identity | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace of the service account to federate | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | The OIDC issuer URL of the AKS cluster for federated identity | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the managed identity will be created | `string` | n/a | yes |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | The Azure role definition to assign to the managed identity (e.g., 'DNS Zone Contributor') | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope at which the role assignment is applied (e.g., DNS zone resource ID) | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The Kubernetes service account name to federate with the managed identity | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the managed identity | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | The client ID of the user-assigned managed identity |
| <a name="output_id"></a> [id](#output\_id) | The resource ID of the user-assigned managed identity |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID of the user-assigned managed identity |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "iam",
  "description": "Creates an Azure user-assigned managed identity with federated credentials for Kubernetes workload identity and assigns an Azure RBAC role",
  "architecture": "The module creates an azurerm_user_assigned_identity resource in the specified resource group and location. It then establishes an azurerm_federated_identity_credential linking the managed identity to a Kubernetes service account via OIDC issuer URL, enabling workload identity federation. Finally, it creates an azurerm_role_assignment granting the managed identity's principal the specified Azure RBAC role at the given scope.",
  "features": [
    "Creates Azure user-assigned managed identity in specified resource group and location",
    "Configures federated identity credential with OIDC issuer for Kubernetes service account authentication",
    "Establishes workload identity federation using api://AzureADTokenExchange audience",
    "Assigns Azure RBAC role to the managed identity at specified scope",
    "Outputs client ID, principal ID, and resource ID for integration with Kubernetes resources",
    "Supports custom tagging for resource organization and cost tracking"
  ],
  "inputs": [
    {
      "name": "resource_group_name",
      "description": "The name of the resource group where the managed identity will be created",
      "required": true
    },
    {
      "name": "location",
      "description": "The Azure region where the managed identity will be created",
      "required": true
    },
    {
      "name": "name",
      "description": "The name of the user-assigned managed identity",
      "required": true
    },
    {
      "name": "oidc_issuer_url",
      "description": "The OIDC issuer URL of the AKS cluster for federated identity",
      "required": true
    },
    {
      "name": "namespace",
      "description": "The Kubernetes namespace of the service account to federate",
      "required": true
    },
    {
      "name": "service_account_name",
      "description": "The Kubernetes service account name to federate with the managed identity",
      "required": true
    },
    {
      "name": "role_definition_name",
      "description": "The Azure role definition to assign to the managed identity (e.g., 'DNS Zone Contributor')",
      "required": true
    },
    {
      "name": "scope",
      "description": "The scope at which the role assignment is applied (e.g., DNS zone resource ID)",
      "required": true
    },
    {
      "name": "tags",
      "description": "A mapping of tags to assign to the managed identity",
      "required": false
    }
  ],
  "outputs": [
    "client_id",
    "principal_id",
    "id"
  ],
  "hash": "532c5b7a2b8a814bba1376ca1189f0a4"
}
END_AI_METADATA -->
