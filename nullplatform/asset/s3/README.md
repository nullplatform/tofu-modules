# Module: s3

## Description

Configures an AWS S3 asset repository in nullplatform, registering the bucket where Lambda and bundle assets are published

## Architecture

The module creates a `nullplatform_provider_config` resource of type `s3-configuration` (a platform-global provider specification in the `assets-repository` category) whose attributes carry the target `bucket.name`. The platform maps this bucket to the `aws.s3_assets_bucket` NRN configuration (via the specification's `runtime_configuration` storage strategy), which the backend reads when generating the S3 upload URL for Lambda/bundle assets. Unlike the `ecr` asset module, this provider config does **not** carry build credentials: the CI publishes S3 assets with the shared build workflow credentials (`BUILD_AWS_*`), so the build workflow user must be granted S3 permissions separately via `infrastructure/aws/iam/s3-assets`.

## Features

- Registers an AWS S3 bucket as a nullplatform asset repository (`s3-configuration` provider config)
- Supplies the `bucket.name` that the platform exposes as `aws.s3_assets_bucket`
- Optionally segments the provider config by `dimensions` (e.g. region, environment)
- Does not manage the bucket or credentials: the bucket is referenced by name and S3 publish permissions are granted by `infrastructure/aws/iam/s3-assets`

## Basic Usage

```hcl
module "asset_s3" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/s3?ref=v5.0.0"

  nrn         = var.nrn
  bucket_name = "your-assets-bucket"
}
```

Grant the build workflow user permission to write to that bucket with the companion IAM module:

```hcl
module "s3_assets" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/s3-assets?ref=v5.0.0"

  cluster_name              = "your-cluster-name"
  build_workflow_group_name = module.build_user.group_name
  assets_bucket             = "your-assets-bucket"
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.88 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.s3](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the existing S3 bucket used as the asset repository, where Lambda/bundle assets are published. Maps to the platform's aws.s3\_assets\_bucket configuration. | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions to segment the nullplatform provider config (e.g. by region, environment) | `map(string)` | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
