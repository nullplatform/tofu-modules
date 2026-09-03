# Module: s3

## Description

Configures an S3 bucket as an asset repository in the nullplatform provider by registering its name under the s3-configuration provider config type

## Architecture

The module creates a single nullplatform_provider_config resource of type s3-configuration tied to the given NRN scope. The bucket_name input is encoded as a JSON attributes payload and passed directly to the provider config resource. No additional resources or data sources are created; the module acts as a thin registration wrapper over the nullplatform provider API.

## Features

- Registers an existing S3 bucket as the nullplatform asset repository configuration
- Encodes bucket metadata as a JSON attributes block for the nullplatform_provider_config resource
- Scopes the S3 provider configuration to a specific nullplatform resource via the NRN identifier
- Supports Lambda and bundle asset publishing workflows by linking the S3 bucket to the platform configuration

## Basic Usage

```hcl
module "s3" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/s3?ref=v7.2.0"

  bucket_name = "your-bucket-name"
  nrn         = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.s3.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.88 |

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
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "s3",
  "description": "Configures an S3 bucket as an asset repository in the nullplatform provider by registering its name under the s3-configuration provider config type",
  "architecture": "The module creates a single nullplatform_provider_config resource of type s3-configuration tied to the given NRN scope. The bucket_name input is encoded as a JSON attributes payload and passed directly to the provider config resource. No additional resources or data sources are created; the module acts as a thin registration wrapper over the nullplatform provider API.",
  "features": [
    "Registers an existing S3 bucket as the nullplatform asset repository configuration",
    "Encodes bucket metadata as a JSON attributes block for the nullplatform_provider_config resource",
    "Scopes the S3 provider configuration to a specific nullplatform resource via the NRN identifier",
    "Supports Lambda and bundle asset publishing workflows by linking the S3 bucket to the platform configuration"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "The nullplatform resource name (NRN)",
      "required": true
    },
    {
      "name": "bucket_name",
      "description": "Name of the existing S3 bucket used as the asset repository, where Lambda/bundle assets are published. Maps to the platform's aws.s3_assets_bucket configuration.",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "3f92707fa998044d837d5c19bcc5cc99"
}
END_AI_METADATA -->
