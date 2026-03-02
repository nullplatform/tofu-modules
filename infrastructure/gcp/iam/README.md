# Module: iam

## Description

Creates and manages Google Cloud Platform service accounts with IAM roles and Workload Identity bindings for Kubernetes integration

## Features

- Creates multiple GCP service accounts with customizable display names
- Assigns IAM roles to service accounts at the project level
- Configures Workload Identity bindings for Kubernetes service account integration
- Supports batch creation of service accounts with role assignments
- Outputs service account email addresses for reference in other modules
- Enables secure authentication between GKE workloads and GCP services

## Basic Usage

```hcl
module "iam" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/iam?ref=v1.41.0"

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
