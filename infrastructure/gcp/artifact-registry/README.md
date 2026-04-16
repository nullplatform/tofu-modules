# Module: artifact-registry

## Description

This module creates a Google Artifact Registry repository with a service account and IAM role for writing to the repository

## Architecture

The module creates a google_artifact_registry_repository resource, a google_service_account resource for Artifact Registry, a google_project_iam_member resource to assign the artifactregistry.writer role to the service account, and a google_service_account_key resource to generate a private key for the service account. The repository_id, location, and project_id variables are used to configure the repository and service account. The format variable determines the type of repository created, with DOCKER being the default. The module outputs the repository ID, repository URL, and service account key JSON.

## Features

- Creates Artifact Registry repository with specified format
- Configures service account with artifactregistry.writer role
- Generates private key for service account

## Basic Usage

```hcl
module "artifact-registry" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/artifact-registry?ref=v1.52.4"

  location      = "your-location"
  project_id    = "your-project-id"
  repository_id = "your-repository-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.artifact-registry.repository_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0, < 7.0 |

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
| <a name="input_format"></a> [format](#input\_format) | The format (DOCKER, NPM, PYTHON, etc) | `string` | `"DOCKER"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location for the repository | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | The repository ID (name) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_id"></a> [repository\_id](#output\_repository\_id) | n/a |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | n/a |
| <a name="output_service_account_key_json"></a> [service\_account\_key\_json](#output\_service\_account\_key\_json) | Service Account key |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "artifact-registry",
  "description": "This module creates a Google Artifact Registry repository with a service account and IAM role for writing to the repository",
  "architecture": "The module creates a google_artifact_registry_repository resource, a google_service_account resource for Artifact Registry, a google_project_iam_member resource to assign the artifactregistry.writer role to the service account, and a google_service_account_key resource to generate a private key for the service account. The repository_id, location, and project_id variables are used to configure the repository and service account. The format variable determines the type of repository created, with DOCKER being the default. The module outputs the repository ID, repository URL, and service account key JSON.",
  "features": [
    "Creates Artifact Registry repository with specified format",
    "Configures service account with artifactregistry.writer role",
    "Generates private key for service account"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "location",
      "description": "The location for the repository",
      "required": true
    },
    {
      "name": "repository_id",
      "description": "The repository ID (name)",
      "required": true
    },
    {
      "name": "format",
      "description": "The format (DOCKER, NPM, PYTHON, etc)",
      "required": false
    }
  ],
  "outputs": [
    "repository_id",
    "repository_url",
    "service_account_key_json"
  ],
  "hash": "f6a763650a3f28f9f48e46f7b721ce8b"
}
END_AI_METADATA -->
