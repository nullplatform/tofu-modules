# Module: backend

## Description

Creates a GCS bucket for Terraform/OpenTofu remote state with access logging, versioning, optional KMS encryption, and IAM member bindings

## Architecture

The module creates a primary google_storage_bucket (tf_state) with a random_id suffix for global uniqueness, and conditionally creates a second google_storage_bucket (logs) when no external log bucket is provided. A data source google_storage_project_service_account retrieves the GCS service agent, and a google_storage_bucket_iam_member (logs_writer) grants it objectCreator on the auto-created log bucket. Additional google_storage_bucket_iam_member resources (allowed_members) are created via for_each to grant objectAdmin to any caller-supplied IAM principals on the state bucket.

## Features

- Creates a globally unique GCS bucket for Terraform/OpenTofu state with a random 16-character hex suffix appended to a caller-supplied prefix
- Enables object versioning by default so previous state revisions can be recovered
- Enforces public access prevention and uniform bucket-level access (IAM-only) by default
- Automatically creates a dedicated access-log bucket and grants the GCS service agent write access when no external log bucket is provided
- Supports optional customer-managed KMS encryption via an existing Cloud KMS key
- Grants additional IAM members roles/storage.objectAdmin on the state bucket via additive IAM bindings
- Applies caller-supplied labels to both the state bucket and the auto-created log bucket

## Basic Usage

```hcl
module "backend" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/backend?ref=v7.3.0"

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
| <a name="provider_google"></a> [google](#provider\_google) | 6.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.9.0 |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.logs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.tf_state](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.allowed_members](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.logs_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_members"></a> [allowed\_members](#input\_allowed\_members) | IAM members (e.g. user:..., serviceAccount:..., group:...) additionally granted roles/storage.objectAdmin on the bucket. These bindings are additive: they grant access on top of whatever the project's IAM already allows, and do not restrict or revoke inherited access | `list(string)` | `[]` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Prefix for the GCS bucket name. A random suffix will be appended since bucket names must be globally unique across all of GCP. Lowercased automatically, since GCS bucket names cannot contain uppercase characters | `string` | `"tofu-state"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destruction of the bucket even if it contains objects. Leave false to protect Terraform/OpenTofu state from accidental deletion | `bool` | `false` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Full resource name of an existing Cloud KMS key used to encrypt the bucket's contents. Leave null or empty to use Google-managed encryption. When set, the project's GCS service agent must already hold roles/cloudkms.cryptoKeyEncrypterDecrypter on the key — this module does not grant it | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | GCS location for the bucket (e.g. a multi-region like US, or a region like us-central1) | `string` | `"US"` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | Name of an existing GCS bucket to receive this bucket's access logs. Leave null or empty and the module creates its own dedicated log bucket (and grants the GCS service agent write access to it) — access logging is always on, so reads of state objects leave an audit trail. | `string` | `null` | no |
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
| <a name="output_log_bucket_name"></a> [log\_bucket\_name](#output\_log\_bucket\_name) | Name of the bucket receiving access logs — either var.log\_bucket, or the module's own auto-created log bucket when that's left unset |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "backend",
  "description": "Creates a GCS bucket for Terraform/OpenTofu remote state with access logging, versioning, optional KMS encryption, and IAM member bindings",
  "architecture": "The module creates a primary google_storage_bucket (tf_state) with a random_id suffix for global uniqueness, and conditionally creates a second google_storage_bucket (logs) when no external log bucket is provided. A data source google_storage_project_service_account retrieves the GCS service agent, and a google_storage_bucket_iam_member (logs_writer) grants it objectCreator on the auto-created log bucket. Additional google_storage_bucket_iam_member resources (allowed_members) are created via for_each to grant objectAdmin to any caller-supplied IAM principals on the state bucket.",
  "features": [
    "Creates a globally unique GCS bucket for Terraform/OpenTofu state with a random 16-character hex suffix appended to a caller-supplied prefix",
    "Enables object versioning by default so previous state revisions can be recovered",
    "Enforces public access prevention and uniform bucket-level access (IAM-only) by default",
    "Automatically creates a dedicated access-log bucket and grants the GCS service agent write access when no external log bucket is provided",
    "Supports optional customer-managed KMS encryption via an existing Cloud KMS key",
    "Grants additional IAM members roles/storage.objectAdmin on the state bucket via additive IAM bindings",
    "Applies caller-supplied labels to both the state bucket and the auto-created log bucket"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID where the state bucket will be created",
      "required": true
    },
    {
      "name": "bucket_prefix",
      "description": "Prefix for the GCS bucket name. A random suffix will be appended since bucket names must be globally unique across all of GCP. Lowercased automatically, since GCS bucket names cannot contain uppercase characters",
      "required": false
    },
    {
      "name": "storage_class",
      "description": "Storage class for the bucket",
      "required": false
    },
    {
      "name": "public_access_prevention",
      "description": "Public access prevention setting for the bucket (enforced or inherited)",
      "required": false
    },
    {
      "name": "location",
      "description": "GCS location for the bucket (e.g. a multi-region like US, or a region like us-central1)",
      "required": false
    },
    {
      "name": "force_destroy",
      "description": "Allow destruction of the bucket even if it contains objects. Leave false to protect Terraform/OpenTofu state from accidental deletion",
      "required": false
    },
    {
      "name": "versioning_enabled",
      "description": "Enable object versioning on the bucket, so previous state revisions can be recovered. Note that prior revisions persist as non-current object versions until a lifecycle rule removes them, so any secret that ever passed through state remains readable in the bucket",
      "required": false
    },
    {
      "name": "uniform_bucket_level_access",
      "description": "Enable uniform bucket-level access (IAM-only, no legacy ACLs)",
      "required": false
    },
    {
      "name": "kms_key_name",
      "description": "Full resource name of an existing Cloud KMS key used to encrypt the bucket's contents. Leave null or empty to use Google-managed encryption. When set, the project's GCS service agent must already hold roles/cloudkms.cryptoKeyEncrypterDecrypter on the key — this module does not grant it",
      "required": false
    },
    {
      "name": "log_bucket",
      "description": "Name of an existing GCS bucket to receive this bucket's access logs. Leave null or empty and the module creates its own dedicated log bucket (and grants the GCS service agent write access to it) — access logging is always on, so reads of state objects leave an audit trail.",
      "required": false
    },
    {
      "name": "allowed_members",
      "description": "IAM members (e.g. user:..., serviceAccount:..., group:...) additionally granted roles/storage.objectAdmin on the bucket. These bindings are additive: they grant access on top of whatever the project's IAM already allows, and do not restrict or revoke inherited access",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of labels to assign to the bucket",
      "required": false
    }
  ],
  "outputs": [
    "bucket_name",
    "bucket_url",
    "bucket_self_link",
    "location",
    "log_bucket_name"
  ],
  "hash": "84e54ab29197e3da7c98e46bd01a5c4a"
}
END_AI_METADATA -->
