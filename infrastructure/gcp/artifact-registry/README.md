# Module: artifact-registry

## Description

Creates a Google Artifact Registry repository with an associated service account configured for Workload Identity bindings to Kubernetes service accounts

## Architecture

The module provisions a google_artifact_registry_repository resource in the specified GCP project and location. A google_service_account is created and granted roles/artifactregistry.writer permissions via google_project_iam_member to enable push/pull operations. For each entry in workload_identity_bindings, a google_service_account_iam_member resource grants roles/iam.workloadIdentityUser to the corresponding Kubernetes service account, establishing the Workload Identity federation link between GKE pods and the GCP service account.

## Features

- Creates Google Artifact Registry repository with configurable format (DOCKER, NPM, PYTHON)
- Provisions a dedicated GCP service account with artifactregistry.writer role for image operations
- Configures Workload Identity bindings to allow Kubernetes service accounts to impersonate the GCP service account
- Outputs fully-qualified Docker-compatible repository URL for image push/pull operations
- Supports custom labels/tags on the Artifact Registry repository
- Enables multi-namespace Kubernetes service account bindings through dynamic for_each configuration

## Basic Usage

```hcl
module "artifact-registry" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/artifact-registry?ref=v7.1.0"

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
| <a name="provider_google"></a> [google](#provider\_google) | 6.50.0 |

## Resources

| Name | Type |
|------|------|
| [google_artifact_registry_repository.registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository) | resource |
| [google_project_iam_member.artifact_sa_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.artifact_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.workload_identity](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_format"></a> [format](#input\_format) | The format (DOCKER, NPM, PYTHON, etc) | `string` | `"DOCKER"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location for the repository | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | The repository ID (name) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of labels to assign to the Artifact Registry repository | `map(string)` | `{}` | no |
| <a name="input_workload_identity_bindings"></a> [workload\_identity\_bindings](#input\_workload\_identity\_bindings) | Kubernetes ServiceAccounts allowed to impersonate the GCP Service Account via Workload Identity. Each entry grants roles/iam.workloadIdentityUser on the GSA to the KSA identified by namespace/ksa\_name. | <pre>list(object({<br/>    namespace = string<br/>    ksa_name  = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_id"></a> [repository\_id](#output\_repository\_id) | The Artifact Registry repository ID |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | The fully-qualified Docker-compatible URL of the Artifact Registry repository |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | GCP Service Account email. Annotate the Kubernetes ServiceAccount bound via workload\_identity\_bindings with iam.gke.io/gcp-service-account=<this value> to impersonate this account from pods. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "artifact-registry",
  "description": "Creates a Google Artifact Registry repository with an associated service account configured for Workload Identity bindings to Kubernetes service accounts",
  "architecture": "The module provisions a google_artifact_registry_repository resource in the specified GCP project and location. A google_service_account is created and granted roles/artifactregistry.writer permissions via google_project_iam_member to enable push/pull operations. For each entry in workload_identity_bindings, a google_service_account_iam_member resource grants roles/iam.workloadIdentityUser to the corresponding Kubernetes service account, establishing the Workload Identity federation link between GKE pods and the GCP service account.",
  "features": [
    "Creates Google Artifact Registry repository with configurable format (DOCKER, NPM, PYTHON)",
    "Provisions a dedicated GCP service account with artifactregistry.writer role for image operations",
    "Configures Workload Identity bindings to allow Kubernetes service accounts to impersonate the GCP service account",
    "Outputs fully-qualified Docker-compatible repository URL for image push/pull operations",
    "Supports custom labels/tags on the Artifact Registry repository",
    "Enables multi-namespace Kubernetes service account bindings through dynamic for_each configuration"
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
    },
    {
      "name": "tags",
      "description": "A mapping of labels to assign to the Artifact Registry repository",
      "required": false
    },
    {
      "name": "workload_identity_bindings",
      "description": "Kubernetes ServiceAccounts allowed to impersonate the GCP Service Account via Workload Identity. Each entry grants roles/iam.workloadIdentityUser on the GSA to the KSA identified by namespace/ksa_name.",
      "required": false
    }
  ],
  "outputs": [
    "repository_id",
    "repository_url",
    "service_account_email"
  ],
  "hash": "e6e32f1a52d8a476263e13e1a9684bdd"
}
END_AI_METADATA -->
