# Module: backend

## Description

Creates a Google Cloud Storage bucket for Terraform/OpenTofu remote state, with optional customer-managed encryption and IAM access restrictions

## Architecture

The module provisions a `google_storage_bucket` resource named by appending a random hex suffix (via `random_id`) to `bucket_prefix`, since GCS bucket names must be globally unique across all of GCP. Uniform bucket-level access and public access prevention are enabled by default, and object versioning is enabled by default so previous state revisions can be recovered. A dynamic `encryption` block is conditionally injected when `kms_key_name` is provided, to encrypt bucket contents with an existing Cloud KMS key instead of Google-managed keys. For each entry in `allowed_members`, a `google_storage_bucket_iam_member` resource grants `roles/storage.objectAdmin` on the bucket to that principal, restricting bucket access beyond the project's default IAM when specified.

## Features

- Creates a GCS bucket with a globally-unique name (configurable prefix plus random suffix)
- Enables object versioning by default to protect against accidental state corruption
- Enables uniform bucket-level access and enforced public access prevention by default
- Supports optional customer-managed encryption via an existing Cloud KMS key
- Supports restricting bucket access to specific IAM members via `roles/storage.objectAdmin` bindings
- Defaults `force_destroy` to false to protect Terraform/OpenTofu state from accidental deletion

## Basic Usage

```hcl
module "backend" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/backend?ref=v6.11.3"

  project_id = "your-project-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.backend.bucket_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0, < 7.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0, < 7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.tf_state](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.allowed_members](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_members"></a> [allowed\_members](#input\_allowed\_members) | IAM members (e.g. user:..., serviceAccount:..., group:...) granted roles/storage.objectAdmin on the bucket. When empty, access follows the project's default IAM | `list(string)` | `[]` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Prefix for the GCS bucket name. A random suffix will be appended since bucket names must be globally unique across all of GCP | `string` | `"tofu-state"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destruction of the bucket even if it contains objects. Leave false to protect Terraform/OpenTofu state from accidental deletion | `bool` | `false` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Full resource name of an existing Cloud KMS key used to encrypt the bucket's contents. Leave null to use Google-managed encryption | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A mapping of labels to assign to the bucket | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | GCS location for the bucket (e.g. a multi-region like US, or a region like us-central1) | `string` | `"US"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where the state bucket will be created | `string` | n/a | yes |
| <a name="input_public_access_prevention"></a> [public\_access\_prevention](#input\_public\_access\_prevention) | Public access prevention setting for the bucket (enforced or inherited) | `string` | `"enforced"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage class for the bucket | `string` | `"STANDARD"` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Enable uniform bucket-level access (IAM-only, no legacy ACLs) | `bool` | `true` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable object versioning on the bucket, so previous state revisions can be recovered | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the GCS bucket for Terraform/OpenTofu state |
| <a name="output_bucket_self_link"></a> [bucket\_self\_link](#output\_bucket\_self\_link) | Self-link of the GCS bucket |
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | gs:// URL of the GCS bucket |
| <a name="output_location"></a> [location](#output\_location) | Location of the GCS bucket |
<!-- END_TF_DOCS -->
