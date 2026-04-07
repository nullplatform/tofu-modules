# Module: acr

## Description

Creates a Google Artifact Registry repository with a service account and IAM role for writing to the registry

## Architecture

The module creates a google_artifact_registry_repository resource, a google_service_account for accessing the registry, a google_project_iam_member to assign the artifactregistry.writer role to the service account, and a google_service_account_key for the service account. The google_artifact_registry_repository resource is configured with the provided project_id, location, and containerregistry_name. The google_service_account and google_project_iam_member resources are used to grant access to the registry. The google_service_account_key resource is used to generate a private key for the service account. The module also outputs the ID of the container registry, the URL of the container registry, and the service account key for container registry access.

## Features

- Creates a Google Artifact Registry repository with a specified format
- Configures a service account with the artifactregistry.writer role for writing to the registry
- Supports custom labels for the container registry via the tags variable

## Basic Usage

```hcl
module "acr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/acr?ref=v1.52.0"

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

<!-- BEGIN_AI_METADATA
{
  "name": "acr",
  "description": "Creates a Google Artifact Registry repository with a service account and IAM role for writing to the registry",
  "architecture": "The module creates a google_artifact_registry_repository resource, a google_service_account for accessing the registry, a google_project_iam_member to assign the artifactregistry.writer role to the service account, and a google_service_account_key for the service account. The google_artifact_registry_repository resource is configured with the provided project_id, location, and containerregistry_name. The google_service_account and google_project_iam_member resources are used to grant access to the registry. The google_service_account_key resource is used to generate a private key for the service account. The module also outputs the ID of the container registry, the URL of the container registry, and the service account key for container registry access.",
  "features": [
    "Creates a Google Artifact Registry repository with a specified format",
    "Configures a service account with the artifactregistry.writer role for writing to the registry",
    "Supports custom labels for the container registry via the tags variable"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "location",
      "description": "The GCP region where the container registry will be created (e.g., us-central1, europe-west1)",
      "required": true
    },
    {
      "name": "containerregistry_name",
      "description": "The name of the container registry (repository ID)",
      "required": true
    },
    {
      "name": "format",
      "description": "The format of the repository (DOCKER, NPM, PYTHON, etc)",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of labels to assign to the container registry",
      "required": false
    }
  ],
  "outputs": [
    "acr_id",
    "acr_login_server",
    "service_account_key_json"
  ],
  "hash": "38472f798a5b4c7a56e630a15ccc98fd"
}
END_AI_METADATA -->
