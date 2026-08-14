# Module: s3

## Description

Configures a nullplatform S3 provider configuration resource linking an existing S3 bucket as the asset repository for a given NRN

## Architecture

The module creates a single nullplatform_provider_config resource of type s3-configuration. The nrn input is used to scope the provider config to a specific nullplatform resource, while bucket_name is encoded as a JSON attribute defining the S3 bucket. The optional dimensions map allows segmenting the configuration by arbitrary key-value pairs such as region or environment.

## Features

- Creates a nullplatform_provider_config resource of type s3-configuration targeting an existing S3 bucket
- Encodes bucket name as a JSON attribute payload within the provider configuration
- Supports dimensional segmentation of the provider config via an optional key-value dimensions map
- Scopes the S3 asset repository configuration to a specific nullplatform resource using the NRN identifier

## Basic Usage

```hcl
module "s3" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/s3?ref=v6.15.0"

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
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions to segment the nullplatform provider config (e.g. by region, environment) | `map(string)` | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "s3",
  "description": "Configures a nullplatform S3 provider configuration resource linking an existing S3 bucket as the asset repository for a given NRN",
  "architecture": "The module creates a single nullplatform_provider_config resource of type s3-configuration. The nrn input is used to scope the provider config to a specific nullplatform resource, while bucket_name is encoded as a JSON attribute defining the S3 bucket. The optional dimensions map allows segmenting the configuration by arbitrary key-value pairs such as region or environment.",
  "features": [
    "Creates a nullplatform_provider_config resource of type s3-configuration targeting an existing S3 bucket",
    "Encodes bucket name as a JSON attribute payload within the provider configuration",
    "Supports dimensional segmentation of the provider config via an optional key-value dimensions map",
    "Scopes the S3 asset repository configuration to a specific nullplatform resource using the NRN identifier"
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
    },
    {
      "name": "dimensions",
      "description": "Dimensions to segment the nullplatform provider config (e.g. by region, environment)",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "6c52d855caa5663ae6f4b3fe5e6b2193"
}
END_AI_METADATA -->
