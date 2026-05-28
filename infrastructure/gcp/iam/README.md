# Module: iam

## Description

This module creates and configures Google Cloud service accounts with IAM roles and workload identity bindings

## Architecture

The module creates google_service_account resources for each service account specified in the service_accounts variable, and google_project_iam_member resources to assign IAM roles to these service accounts. It also creates google_service_account_iam_member resources to establish workload identity bindings between GCP service accounts and Kubernetes service accounts. The module uses Terraform's for_each argument to iterate over the service_accounts and workload_identity_bindings variables, creating the necessary resources and bindings. The module outputs a map of service account names to their email addresses.

## Features

- Creates Google Cloud service accounts with custom display names
- Assigns IAM roles to service accounts using google_project_iam_member resources
- Establishes workload identity bindings between GCP service accounts and Kubernetes service accounts
- Outputs a map of service account names to their email addresses

## Basic Usage

```hcl
module "iam" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/iam?ref=v3.5.1"

  project_id = "your-project-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.iam.service_accounts
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.sa_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.workload_identity](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | List of service accounts to create with their roles | <pre>list(object({<br/>    name         = string<br/>    display_name = optional(string)<br/>    roles        = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_workload_identity_bindings"></a> [workload\_identity\_bindings](#input\_workload\_identity\_bindings) | Workload Identity bindings (GCP Service Account -> Kubernetes Service Account) | <pre>list(object({<br/>    service_account_email = string<br/>    namespace             = string<br/>    ksa_name              = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | A map of service account names to their email addresses |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "iam",
  "description": "This module creates and configures Google Cloud service accounts with IAM roles and workload identity bindings",
  "architecture": "The module creates google_service_account resources for each service account specified in the service_accounts variable, and google_project_iam_member resources to assign IAM roles to these service accounts. It also creates google_service_account_iam_member resources to establish workload identity bindings between GCP service accounts and Kubernetes service accounts. The module uses Terraform's for_each argument to iterate over the service_accounts and workload_identity_bindings variables, creating the necessary resources and bindings. The module outputs a map of service account names to their email addresses.",
  "features": [
    "Creates Google Cloud service accounts with custom display names",
    "Assigns IAM roles to service accounts using google_project_iam_member resources",
    "Establishes workload identity bindings between GCP service accounts and Kubernetes service accounts",
    "Outputs a map of service account names to their email addresses"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "service_accounts",
      "description": "List of service accounts to create with their roles",
      "required": false
    },
    {
      "name": "workload_identity_bindings",
      "description": "Workload Identity bindings (GCP Service Account -> Kubernetes Service Account)",
      "required": false
    }
  ],
  "outputs": [
    "service_accounts"
  ],
  "hash": "b8d10842d75bfb787da9e0ca0df44a53"
}
END_AI_METADATA -->
