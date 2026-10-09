# Module: unknown_scope

## Description

Creates an Azure Managed Identity with federated OIDC credentials and assigns a role to a specified scope for Kubernetes workload identity

## Architecture

The module creates an azurerm_user_assigned_identity resource as the core Managed Identity, then configures an azurerm_federated_identity_credential to bind it to a Kubernetes service account via OIDC issuer URL and namespace. An azurerm_role_assignment resource links the identity to a specified Azure resource scope using a named role definition. The client_id of the Managed Identity is exposed as an output for use by Kubernetes workloads.

## Features

- Creates an Azure User Assigned Managed Identity in a specified resource group and location
- Configures federated identity credentials linking the identity to a Kubernetes service account via OIDC issuer URL
- Assigns a named Azure role definition to the Managed Identity against a specified resource scope
- Exposes the Managed Identity client_id as an output for workload identity annotation in Kubernetes

## Basic Usage

```hcl
module "unknown_scope" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/iam/tests/fixtures/unknown_scope?ref=v8.5.0"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.unknown_scope.client_id
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam"></a> [iam](#module\_iam) | ../../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_data.zone](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | n/a |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "unknown_scope",
  "description": "Creates an Azure Managed Identity with federated OIDC credentials and assigns a role to a specified scope for Kubernetes workload identity",
  "architecture": "The module creates an azurerm_user_assigned_identity resource as the core Managed Identity, then configures an azurerm_federated_identity_credential to bind it to a Kubernetes service account via OIDC issuer URL and namespace. An azurerm_role_assignment resource links the identity to a specified Azure resource scope using a named role definition. The client_id of the Managed Identity is exposed as an output for use by Kubernetes workloads.",
  "features": [
    "Creates an Azure User Assigned Managed Identity in a specified resource group and location",
    "Configures federated identity credentials linking the identity to a Kubernetes service account via OIDC issuer URL",
    "Assigns a named Azure role definition to the Managed Identity against a specified resource scope",
    "Exposes the Managed Identity client_id as an output for workload identity annotation in Kubernetes"
  ],
  "inputs": [],
  "outputs": [
    "client_id"
  ],
  "hash": "9f7f29b24959a6e27e070eb8865d6adf"
}
END_AI_METADATA -->
