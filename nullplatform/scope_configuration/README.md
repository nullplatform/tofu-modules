# Module: scope_configuration

## Description

Creates a Nullplatform provider configuration (scope configuration) resource associated with a specific provider specification and NRN

## Architecture

The module creates a single nullplatform_provider_config resource that binds a Nullplatform Resource Name (NRN) to a provider specification type defined by the provider_specification_slug. The attributes input is JSON-encoded before being passed to the resource, and dimension values are passed as a map to scope the configuration. The resource uses a lifecycle ignore_changes rule on attributes to prevent drift detection after initial creation. The resource ID is exposed as an output for downstream module consumption.

## Features

- Creates a nullplatform_provider_config resource linked to a specific NRN and provider specification slug
- Encodes configuration attributes as JSON to match the provider specification schema
- Supports dimensional scoping of provider configurations via a key-value dimension map
- Prevents attribute drift after initial creation using Terraform lifecycle ignore_changes
- Exposes the created provider config ID as an output for downstream reference

## Basic Usage

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v6.22.1"

  attributes                  = "your-attributes"
  np_api_key                  = "your-np-api-key"
  nrn                         = "your-nrn"
  provider_specification_slug = "your-provider-specification-slug"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.scope_configuration.provider_config_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.scope_configuration](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_distribution"></a> [aws\_distribution](#input\_aws\_distribution) | CDN distribution for serving static files. | `string` | `"cloudfront"` | no |
| <a name="input_aws_hosted_public_zone_id"></a> [aws\_hosted\_public\_zone\_id](#input\_aws\_hosted\_public\_zone\_id) | Public hosted zone ID for DNS records (e.g., Z1234567890ABC). | `string` | `null` | no |
| <a name="input_aws_network"></a> [aws\_network](#input\_aws\_network) | DNS provider for managing records. | `string` | `"route53"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where resources will be deployed. | `string` | `null` | no |
| <a name="input_aws_security"></a> [aws\_security](#input\_aws\_security) | Optional WAF attachment for the CloudFront distribution. Choose 'none' to skip, or 'waf' to attach an existing AWS WAF WebACL. | `string` | `"none"` | no |
| <a name="input_aws_state_bucket"></a> [aws\_state\_bucket](#input\_aws\_state\_bucket) | S3 bucket name for storing OpenTofu state (also used for S3-native state locking). | `string` | `null` | no |
| <a name="input_aws_web_acl_name"></a> [aws\_web\_acl\_name](#input\_aws\_web\_acl\_name) | Name of an existing AWS WAF WebACL with scope=CLOUDFRONT. Only used when aws\_security = "waf". | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | static-files only. Cloud provider for this static-files scope configuration. | `string` | `null` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimension values for this configuration. | `map(string)` | `{}` | no |
| <a name="input_lambda_available_layers"></a> [lambda\_available\_layers](#input\_lambda\_available\_layers) | aws-lambda-configuration only. Lambda layer ARNs made available for developers to select when creating scopes. | `list(string)` | `[]` | no |
| <a name="input_lambda_certificate_arn"></a> [lambda\_certificate\_arn](#input\_lambda\_certificate\_arn) | aws-lambda-configuration only. ARN of the certificate to use for the function. Required when lambda\_enable\_endpoint is true (the default). | `string` | `null` | no |
| <a name="input_lambda_enable_endpoint"></a> [lambda\_enable\_endpoint](#input\_lambda\_enable\_endpoint) | aws-lambda-configuration only. Whether to create an endpoint domain. If true, lambda\_certificate\_arn is required. | `bool` | `true` | no |
| <a name="input_lambda_provisioned_concurrency_type"></a> [lambda\_provisioned\_concurrency\_type](#input\_lambda\_provisioned\_concurrency\_type) | aws-lambda-configuration only. 'unprovisioned' (default AWS behavior) or 'provisioned' (set a specific limit via lambda\_provisioned\_concurrency\_value). | `string` | `"unprovisioned"` | no |
| <a name="input_lambda_provisioned_concurrency_value"></a> [lambda\_provisioned\_concurrency\_value](#input\_lambda\_provisioned\_concurrency\_value) | aws-lambda-configuration only. Provisioned concurrency for this function. Required when lambda\_provisioned\_concurrency\_type is 'provisioned'. | `number` | `null` | no |
| <a name="input_lambda_reserved_concurrency_type"></a> [lambda\_reserved\_concurrency\_type](#input\_lambda\_reserved\_concurrency\_type) | aws-lambda-configuration only. 'unreserved' (default AWS behavior) or 'reserved' (set a specific limit via lambda\_reserved\_concurrency\_value). | `string` | `"unreserved"` | no |
| <a name="input_lambda_reserved_concurrency_value"></a> [lambda\_reserved\_concurrency\_value](#input\_lambda\_reserved\_concurrency\_value) | aws-lambda-configuration only. Number of concurrent executions to reserve (1-1000). Required when lambda\_reserved\_concurrency\_type is 'reserved'. | `number` | `null` | no |
| <a name="input_lambda_role_arn"></a> [lambda\_role\_arn](#input\_lambda\_role\_arn) | aws-lambda-configuration only. ARN of the IAM role to use for the function. | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (NRN) — unique identifier for the target resource. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Provider specification slug this scope configuration targets. Determines which set of variables below applies — see README for each type's payload. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | ID of the created provider config. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_configuration",
  "description": "Creates a Nullplatform provider configuration (scope configuration) resource associated with a specific provider specification and NRN",
  "architecture": "The module creates a single nullplatform_provider_config resource that binds a Nullplatform Resource Name (NRN) to a provider specification type defined by the provider_specification_slug. The attributes input is JSON-encoded before being passed to the resource, and dimension values are passed as a map to scope the configuration. The resource uses a lifecycle ignore_changes rule on attributes to prevent drift detection after initial creation. The resource ID is exposed as an output for downstream module consumption.",
  "features": [
    "Creates a nullplatform_provider_config resource linked to a specific NRN and provider specification slug",
    "Encodes configuration attributes as JSON to match the provider specification schema",
    "Supports dimensional scoping of provider configurations via a key-value dimension map",
    "Prevents attribute drift after initial creation using Terraform lifecycle ignore_changes",
    "Exposes the created provider config ID as an output for downstream reference"
  ],
  "inputs": [
    {
      "name": "np_api_key",
      "description": "Nullplatform API key for authentication.",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (NRN) — unique identifier for the target resource.",
      "required": true
    },
    {
      "name": "attributes",
      "description": "Configuration attributes matching the provider specification schema.",
      "required": true
    },
    {
      "name": "provider_specification_slug",
      "description": "Slug of the provider specification (scope configuration type) to associate with.",
      "required": true
    },
    {
      "name": "dimensions",
      "description": "Dimension values for this configuration.",
      "required": false
    }
  ],
  "outputs": [
    "provider_config_id"
  ],
  "hash": "05a6b14a1bad1e51d5cb3708971964d8"
}
END_AI_METADATA -->
