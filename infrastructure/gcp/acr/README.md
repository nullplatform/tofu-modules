# Module: acr

## Description

Provisions a Google Artifact Registry repository with a dedicated service account for push/pull operations

## Features

- Creates a Google Artifact Registry repository with configurable format
- Provisions a dedicated service account with Artifact Registry writer permissions
- Generates service account key for authentication
- Supports multiple artifact formats including Docker, NPM, and Python
- Applies custom labels to the registry for organization and cost tracking
- Outputs repository URL and sensitive service account credentials

## Basic Usage

```hcl
module "acr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/acr?ref=v1.34.0"

  containerregistry_name = "your-containerregistry-name"
  location               = "your-location"
  project_id             = "your-project-id"
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [google_artifact_registry_repository.registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository) | resource |
| [google_project_iam_member.artifact_sa_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.artifact_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.artifact_sa_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_containerregistry_name"></a> [containerregistry\_name](#input\_containerregistry\_name) | The name of the container registry (repository ID) | `string` | n/a | yes |
| <a name="input_format"></a> [format](#input\_format) | The format of the repository (DOCKER, NPM, PYTHON, etc) | `string` | `"DOCKER"` | no |
| <a name="input_location"></a> [location](#input\_location) | The GCP region where the container registry will be created (e.g., us-central1, europe-west1) | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of labels to assign to the container registry | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | The ID of the container registry |
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | The URL of the container registry |
| <a name="output_service_account_key_json"></a> [service\_account\_key\_json](#output\_service\_account\_key\_json) | The Service Account key for container registry access |
<!-- END_TF_DOCS -->
