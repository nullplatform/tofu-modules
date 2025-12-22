<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0 |

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
| <a name="input_workload_identity_bindings"></a> [workload\_identity\_bindings](#input\_workload\_identity\_bindings) | Workload Identity bindings (GSA -> KSA) | <pre>list(object({<br/>    service_account_email = string<br/>    namespace             = string<br/>    ksa_name              = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | n/a |
<!-- END_TF_DOCS -->