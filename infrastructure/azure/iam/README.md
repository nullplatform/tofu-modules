# Module: iam

## Description

Creates an Azure user-assigned managed identity with federated identity credentials for AKS workload identity, optionally assigning Azure RBAC roles

## Architecture

The module creates an azurerm_user_assigned_identity resource as its core, then wires an azurerm_federated_identity_credential to it using the identity's resource ID as parent_id, binding the AKS OIDC issuer URL to a Kubernetes service account subject string composed from the namespace and service_account_name inputs. An optional azurerm_role_assignment.this is conditionally created (count-based) when both role_definition_name and scope are provided, and an additional azurerm_role_assignment.additional for_each map supports multiple supplementary role assignments, all referencing the identity's principal_id. Outputs expose the identity's client_id, principal_id, and resource ID for downstream consumption.

## Features

- Creates an Azure user-assigned managed identity with configurable name, resource group, location, and tags
- Configures a federated identity credential linking the managed identity to a specific Kubernetes service account via AKS OIDC issuer URL
- Assigns a single Azure RBAC role at a specified scope when both role_definition_name and scope are provided
- Supports multiple additional role assignments via a map input with plan-time-stable keys
- Enforces mutual dependency between scope and role_definition_name using lifecycle preconditions
- Outputs client_id, principal_id, and resource ID for use by downstream Kubernetes workload identity configurations

## Basic Usage

```hcl
module "iam" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/iam?ref=v8.5.0"

  location             = "your-location"
  name                 = "your-name"
  namespace            = "your-namespace"
  oidc_issuer_url      = "your-oidc-issuer-url"
  resource_group_name  = "your-resource-group-name"
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.81.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.additional](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
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
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | Additional role assignments for the identity, keyed by a static name of your choice (e.g. "dns\_public"). Keys must be known at plan time; scopes may be known only after apply | <pre>map(object({<br/>    role_definition_name = string<br/>    scope                = string<br/>  }))</pre> | `{}` | no |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | The Azure role definition to assign to the managed identity (e.g., 'DNS Zone Contributor'). Optional: leave null and use role\_assignments instead. Must be set together with scope | `string` | `null` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope at which the role assignment is applied (e.g., DNS zone resource ID). Optional: leave null and use role\_assignments instead. Must be set together with role\_definition\_name | `string` | `null` | no |
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
  "description": "Creates an Azure user-assigned managed identity with federated identity credentials for AKS workload identity, optionally assigning Azure RBAC roles",
  "architecture": "The module creates an azurerm_user_assigned_identity resource as its core, then wires an azurerm_federated_identity_credential to it using the identity's resource ID as parent_id, binding the AKS OIDC issuer URL to a Kubernetes service account subject string composed from the namespace and service_account_name inputs. An optional azurerm_role_assignment.this is conditionally created (count-based) when both role_definition_name and scope are provided, and an additional azurerm_role_assignment.additional for_each map supports multiple supplementary role assignments, all referencing the identity's principal_id. Outputs expose the identity's client_id, principal_id, and resource ID for downstream consumption.",
  "features": [
    "Creates an Azure user-assigned managed identity with configurable name, resource group, location, and tags",
    "Configures a federated identity credential linking the managed identity to a specific Kubernetes service account via AKS OIDC issuer URL",
    "Assigns a single Azure RBAC role at a specified scope when both role_definition_name and scope are provided",
    "Supports multiple additional role assignments via a map input with plan-time-stable keys",
    "Enforces mutual dependency between scope and role_definition_name using lifecycle preconditions",
    "Outputs client_id, principal_id, and resource ID for use by downstream Kubernetes workload identity configurations"
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
      "description": "The Azure role definition to assign to the managed identity (e.g., 'DNS Zone Contributor'). Optional: leave null and use role_assignments instead. Must be set together with scope",
      "required": false
    },
    {
      "name": "scope",
      "description": "The scope at which the role assignment is applied (e.g., DNS zone resource ID). Optional: leave null and use role_assignments instead. Must be set together with role_definition_name",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of tags to assign to the managed identity",
      "required": false
    },
    {
      "name": "role_assignments",
      "description": "Additional role assignments for the identity, keyed by a static name of your choice (e.g. \\",
      "required": false
    }
  ],
  "outputs": [
    "client_id",
    "principal_id",
    "id"
  ],
  "hash": "89986085d51417f834e49e387111f737"
}
END_AI_METADATA -->
