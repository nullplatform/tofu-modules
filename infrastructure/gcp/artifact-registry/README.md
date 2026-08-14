# Module: artifact-registry

## Description

Creates a Google Artifact Registry repository with a dedicated service account, Workload Identity bindings for Kubernetes, and optional static key generation for external Docker clients

## Architecture

The module creates a google_artifact_registry_repository resource configured with the specified format and labels, alongside a google_service_account named artifact-registry-sa. A google_project_iam_member binds roles/artifactregistry.writer to the service account at project scope, while google_service_account_iam_member resources (one per entry in workload_identity_bindings) grant roles/iam.workloadIdentityUser to each Kubernetes ServiceAccount via GKE Workload Identity federation. An optional google_service_account_key is created when generate_key is true, with keepers wired to key_rotation_token to control forced key rotation.

## Features

- Creates a google_artifact_registry_repository supporting DOCKER, NPM, PYTHON, and other formats
- Creates a dedicated google_service_account with roles/artifactregistry.writer bound at project scope
- Configures Workload Identity bindings via google_service_account_iam_member for multiple Kubernetes ServiceAccounts across namespaces
- Generates an optional static JSON service account key via google_service_account_key for external Docker registry clients
- Supports key rotation by wiring a caller-controlled token to the key's keepers map
- Outputs a fully-qualified Docker-compatible repository URL for immediate use in image push/pull configurations

## Basic Usage

```hcl
module "artifact-registry" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/artifact-registry?ref=v6.16.0"

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
| [google_service_account_key.artifact_sa_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_format"></a> [format](#input\_format) | The format (DOCKER, NPM, PYTHON, etc) | `string` | `"DOCKER"` | no |
| <a name="input_generate_key"></a> [generate\_key](#input\_generate\_key) | Generate a static JSON key for the Artifact Registry service account, exposed via the service\_account\_key\_base64 output. Only needed for callers outside the cluster (e.g. an external system authenticating as a Docker registry client) that can't use Workload Identity. Leave false when every consumer runs in-cluster. Note that the key material is stored in plaintext in Terraform/OpenTofu state, and the service account holds roles/artifactregistry.writer at PROJECT scope. | `bool` | `false` | no |
| <a name="input_key_rotation_token"></a> [key\_rotation\_token](#input\_key\_rotation\_token) | Arbitrary value wired to the service account key's keepers. Changing it forces a new key to be issued, which is the supported way to rotate: GCP user-managed keys do not expire on their own. Leave null to never rotate. Do not derive this from timestamp() or uuid() — the key would be reissued on every apply | `string` | `null` | no |
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
| <a name="output_service_account_key_base64"></a> [service\_account\_key\_base64](#output\_service\_account\_key\_base64) | Base64-encoded JSON key for the Artifact Registry service account, for Docker clients that authenticate with username '\_json\_key\_base64' and this value as the password. Null unless generate\_key is true. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "artifact-registry",
  "description": "Creates a Google Artifact Registry repository with a dedicated service account, Workload Identity bindings for Kubernetes, and optional static key generation for external Docker clients",
  "architecture": "The module creates a google_artifact_registry_repository resource configured with the specified format and labels, alongside a google_service_account named artifact-registry-sa. A google_project_iam_member binds roles/artifactregistry.writer to the service account at project scope, while google_service_account_iam_member resources (one per entry in workload_identity_bindings) grant roles/iam.workloadIdentityUser to each Kubernetes ServiceAccount via GKE Workload Identity federation. An optional google_service_account_key is created when generate_key is true, with keepers wired to key_rotation_token to control forced key rotation.",
  "features": [
    "Creates a google_artifact_registry_repository supporting DOCKER, NPM, PYTHON, and other formats",
    "Creates a dedicated google_service_account with roles/artifactregistry.writer bound at project scope",
    "Configures Workload Identity bindings via google_service_account_iam_member for multiple Kubernetes ServiceAccounts across namespaces",
    "Generates an optional static JSON service account key via google_service_account_key for external Docker registry clients",
    "Supports key rotation by wiring a caller-controlled token to the key's keepers map",
    "Outputs a fully-qualified Docker-compatible repository URL for immediate use in image push/pull configurations"
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
    },
    {
      "name": "generate_key",
      "description": "Generate a static JSON key for the Artifact Registry service account, exposed via the service_account_key_base64 output. Only needed for callers outside the cluster (e.g. an external system authenticating as a Docker registry client) that can't use Workload Identity. Leave false when every consumer runs in-cluster. Note that the key material is stored in plaintext in Terraform/OpenTofu state, and the service account holds roles/artifactregistry.writer at PROJECT scope.",
      "required": false
    },
    {
      "name": "key_rotation_token",
      "description": "Arbitrary value wired to the service account key's keepers. Changing it forces a new key to be issued, which is the supported way to rotate: GCP user-managed keys do not expire on their own. Leave null to never rotate. Do not derive this from timestamp() or uuid() — the key would be reissued on every apply",
      "required": false
    }
  ],
  "outputs": [
    "repository_id",
    "repository_url",
    "service_account_email",
    "service_account_key_base64"
  ],
  "hash": "98650a4313945da06253fd16d10cedec"
}
END_AI_METADATA -->
