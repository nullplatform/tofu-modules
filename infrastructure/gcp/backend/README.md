# Module: backend

## Description

Creates a Google Cloud Storage bucket for Terraform/OpenTofu remote state, with optional customer-managed encryption, access logging, and additional IAM grants

## Architecture

The module provisions a `google_storage_bucket` resource named by appending a random hex suffix (via `random_id`) to a lowercased `bucket_prefix`, since GCS bucket names must be globally unique across all of GCP and cannot contain uppercase characters. Uniform bucket-level access and public access prevention are enabled by default, and object versioning is enabled by default so previous state revisions can be recovered. A dynamic `encryption` block is conditionally injected when `kms_key_name` is set, to encrypt bucket contents with an existing Cloud KMS key instead of Google-managed keys, and a dynamic `logging` block is injected when `log_bucket` is set. For each entry in `allowed_members`, a `google_storage_bucket_iam_member` resource grants `roles/storage.objectAdmin` on the bucket to that principal — these bindings are additive and do not restrict or revoke access inherited from the project's IAM.

## Features

- Creates a GCS bucket with a globally-unique name (configurable prefix plus random suffix)
- Enables object versioning by default to protect against accidental state corruption
- Enables uniform bucket-level access and enforced public access prevention by default
- Supports optional customer-managed encryption via an existing Cloud KMS key
- Supports optional access logging to an existing log bucket, so reads of state objects leave an audit trail
- Grants `roles/storage.objectAdmin` to additional IAM members (additive, on top of project-inherited access)
- Defaults `force_destroy` to false to protect Terraform/OpenTofu state from accidental deletion
- Validates `bucket_prefix`, `storage_class` and `public_access_prevention` at plan time, so an illegal value fails before apply

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

## Bootstrapping the backend

The bucket name is only known after apply, because it embeds a `random_id` suffix. A `backend "gcs"` block requires a literal bucket name, so adopting this module is a two-phase operation:

1. Apply this module with a local state file and read `bucket_name` from the output.
2. Add the `backend "gcs"` block with that literal name and run `tofu init -migrate-state`.

```hcl
terraform {
  backend "gcs" {
    bucket = "tofu-state-a1b2c3d4e5f6a7b8" # from module.backend.bucket_name
    prefix = "your-stack"
  }
}
```

## Operational notes

**Access is additive, not restricted.** `allowed_members` only grants. Every principal that already holds `roles/editor`, `roles/storage.admin` or `roles/storage.objectViewer` on the project keeps full read access to the bucket, and state contains secrets in plaintext. Restricting access to state means tightening project-level IAM; this module cannot do it for you. (`google_storage_bucket_iam_member` is used deliberately over `google_storage_bucket_iam_binding`, which is authoritative and would wipe bindings the module does not manage.)

**Versioning retains secrets after rotation.** With `versioning_enabled = true` (the default), removing or rotating a secret in state leaves the previous value readable as a non-current object version. There is no lifecycle rule to age those out — add one if your threat model requires that rotated credentials become unrecoverable.

**Customer-managed encryption has a prerequisite this module does not create.** Before `kms_key_name` can be set, the project's GCS service agent (`service-<PROJECT_NUMBER>@gs-project-accounts.iam.gserviceaccount.com`) must hold `roles/cloudkms.cryptoKeyEncrypterDecrypter` on the key. Grant it separately — for example with a `google_kms_crypto_key_iam_member` alongside this module — or apply fails with `permission denied on Cloud KMS key`.

**Changing `bucket_prefix` replaces the bucket.** The name is the only forces-replacement attribute. With `force_destroy = false` the destroy fails on a non-empty bucket, leaving a half-applied bootstrap to untangle by hand. Treat the prefix as immutable once state lives in the bucket.

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
| <a name="provider_google"></a> [google](#provider\_google) | 6.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.9.0 |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.tf_state](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.allowed_members](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_members"></a> [allowed\_members](#input\_allowed\_members) | IAM members (e.g. user:..., serviceAccount:..., group:...) additionally granted roles/storage.objectAdmin on the bucket. These bindings are additive: they grant access on top of whatever the project's IAM already allows, and do not restrict or revoke inherited access | `list(string)` | `[]` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Prefix for the GCS bucket name. A random suffix will be appended since bucket names must be globally unique across all of GCP. Lowercased automatically, since GCS bucket names cannot contain uppercase characters | `string` | `"tofu-state"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destruction of the bucket even if it contains objects. Leave false to protect Terraform/OpenTofu state from accidental deletion | `bool` | `false` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Full resource name of an existing Cloud KMS key used to encrypt the bucket's contents. Leave null or empty to use Google-managed encryption. When set, the project's GCS service agent must already hold roles/cloudkms.cryptoKeyEncrypterDecrypter on the key — this module does not grant it | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | GCS location for the bucket (e.g. a multi-region like US, or a region like us-central1) | `string` | `"US"` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | Name of an existing GCS bucket to receive this bucket's access logs. Leave null or empty to disable access logging. Recommended for a state bucket, so reads of state objects leave an audit trail | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where the state bucket will be created | `string` | n/a | yes |
| <a name="input_public_access_prevention"></a> [public\_access\_prevention](#input\_public\_access\_prevention) | Public access prevention setting for the bucket (enforced or inherited) | `string` | `"enforced"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage class for the bucket | `string` | `"STANDARD"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of labels to assign to the bucket | `map(string)` | `{}` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Enable uniform bucket-level access (IAM-only, no legacy ACLs) | `bool` | `true` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable object versioning on the bucket, so previous state revisions can be recovered. Note that prior revisions persist as non-current object versions until a lifecycle rule removes them, so any secret that ever passed through state remains readable in the bucket | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the GCS bucket for Terraform/OpenTofu state |
| <a name="output_bucket_self_link"></a> [bucket\_self\_link](#output\_bucket\_self\_link) | Self-link of the GCS bucket |
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | gs:// URL of the GCS bucket |
| <a name="output_location"></a> [location](#output\_location) | Location of the GCS bucket |
<!-- END_TF_DOCS -->
