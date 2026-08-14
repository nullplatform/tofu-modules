# Module: artifact-registry

## Description

Creates a Google Artifact Registry repository with an associated service account configured for Workload Identity bindings to Kubernetes service accounts

## Architecture

The module provisions a google_artifact_registry_repository resource in the specified GCP project and location. A google_service_account is created and granted roles/artifactregistry.writer permissions via google_project_iam_member to enable push/pull operations. For each entry in workload_identity_bindings, a google_service_account_iam_member resource grants roles/iam.workloadIdentityUser to the corresponding Kubernetes service account, establishing the Workload Identity federation link between GKE pods and the GCP service account. When generate_key is true, a google_service_account_key is also created and its base64-encoded private key exposed via service_account_key_base64, for callers outside the cluster that can't use Workload Identity and need to authenticate as a Docker client instead.

## Features

- Creates Google Artifact Registry repository with configurable format (DOCKER, NPM, PYTHON)
- Provisions a dedicated GCP service account with artifactregistry.writer role for image operations
- Configures Workload Identity bindings to allow Kubernetes service accounts to impersonate the GCP service account
- Outputs fully-qualified Docker-compatible repository URL for image push/pull operations
- Supports custom labels/tags on the Artifact Registry repository
- Enables multi-namespace Kubernetes service account bindings through dynamic for_each configuration
- Optionally generates a static JSON key for the service account, for non-cluster Docker clients that can't use Workload Identity

## Basic Usage

```hcl
module "artifact-registry" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/artifact-registry?ref=v6.14.0"

  location      = "your-location"
  project_id    = "your-project-id"
  repository_id = "your-repository-id"
}
```

### Usage with a Static Docker Credential

```hcl
module "artifact-registry" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/artifact-registry?ref=v6.14.0"

  location      = "your-location"
  project_id    = "your-project-id"
  repository_id = "your-repository-id"

  generate_key = true
}

# module.artifact-registry.service_account_key_base64 is the password for a
# Docker client authenticating with username "_json_key_base64".
```

The output is the key exactly as the provider returns it: base64-encoded JSON. That is what the `_json_key_base64` username expects, so pass it through unchanged. Docker clients using the older `_json_key` username need the decoded form instead — wrap it in `base64decode()`.

#### Before enabling `generate_key`

**The key material is stored in plaintext in state.** `sensitive = true` on the output redacts CLI display, not state. Anyone who can read the state backend obtains a working credential, so `generate_key = true` requires a state bucket restricted to operators. Prefer `workload_identity_bindings` for anything running in-cluster — it needs no key at all.

**The credential is project-scoped, not repository-scoped.** The service account holds `roles/artifactregistry.writer` on the whole project (`google_project_iam_member`), so a leaked key can push and overwrite tags in *every* Artifact Registry repository in `project_id`, not just this one. Size the blast radius accordingly; a repository-scoped grant would need `google_artifact_registry_repository_iam_member` instead.

**Rotation is manual.** GCP user-managed service account keys do not expire. Set `key_rotation_token` to any value and change it to force a new key — that is the supported rotation path. Do not derive it from `timestamp()` or `uuid()`, which would reissue the key on every apply.

**The key cannot be recovered after state loss.** The provider only populates `private_key` when it creates the key, so a `state rm` plus import, or a state restore, brings the attribute back empty and the output silently becomes empty rather than erroring. Recover by forcing a new key (change `key_rotation_token`, or `tofu apply -replace`) and redistributing it.

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
