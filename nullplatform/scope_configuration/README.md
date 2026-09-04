# Module: scope_configuration

## Description

Creates and manages a nullplatform provider scope configuration resource for either static-files (CloudFront/S3/Route53) or aws-lambda deployment types

## Architecture

The module creates a single nullplatform_provider_config resource, wiring the nrn, type, and dimensions inputs directly into it. The attributes payload is built by merging type-specific default maps with override maps computed in locals.tf — for static-files, cloud-provider-keyed overrides assemble distribution, network, security, and provider sub-objects; for aws-lambda, state and deployment objects are merged with an optional agent block when lambda_null_agent_layer_arn is provided. The final merged map is JSON-encoded and passed as the attributes argument, while the resource id is surfaced as the provider_config_id output.

## Features

- Creates a nullplatform_provider_config resource encoding provider-specific attributes as a JSON payload
- Configures static-files scope with CloudFront distribution, Route53 DNS, optional WAF WebACL attachment, and Lambda@Edge associations
- Configures aws-lambda scope with OpenTofu state bucket, ECR placeholder image URI, and optional nullplatform agent Lambda layer
- Merges provider-type defaults with caller-supplied overrides to prevent drift against unset optional fields
- Conditionally includes lambda_associations and agent blocks only when their inputs are non-empty, avoiding drift on configs that never declared them
- Validates each variable's applicability to the selected type and cloud provider to prevent misconfiguration

## Basic Usage

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v7.3.0"

  nrn  = "your-nrn"
  type = "your-type"
}
```

### Usage with Static Files

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v7.3.0"

  aws_hosted_public_zone_id = "your-aws-hosted-public-zone-id"  # Required when type = "static-files"
  aws_region                = "your-aws-region"  # Required when type = "static-files"
  aws_state_bucket          = "your-aws-state-bucket"  # Required when type = "static-files"
  cloud_provider            = "your-cloud-provider"  # Required when type = "static-files"
  nrn                       = "your-nrn"
  type                      = "static-files"
}
```

### Usage with AWS Lambda

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v7.3.0"

  lambda_placeholder_image_uri = "your-lambda-placeholder-image-uri"  # Required when type = "aws-lambda"
  lambda_tofu_state_bucket     = "your-lambda-tofu-state-bucket"  # Required when type = "aws-lambda"
  nrn                          = "your-nrn"
  type                         = "aws-lambda"
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
| <a name="input_aws_lambda_associations"></a> [aws\_lambda\_associations](#input\_aws\_lambda\_associations) | Lambda@Edge functions attached to the CloudFront default cache behavior, one entry per CloudFront event. function\_arn must include a published version. Empty (the default) leaves distribution.lambda\_associations out of the payload, matching a spec that never declared it. | <pre>list(object({<br/>    event_type   = string<br/>    function_arn = string<br/>  }))</pre> | `[]` | no |
| <a name="input_aws_network"></a> [aws\_network](#input\_aws\_network) | DNS provider for managing records. | `string` | `"route53"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where resources will be deployed. | `string` | `null` | no |
| <a name="input_aws_security"></a> [aws\_security](#input\_aws\_security) | Optional WAF attachment for the CloudFront distribution. Choose 'none' to skip, or 'waf' to attach an existing AWS WAF WebACL. | `string` | `"none"` | no |
| <a name="input_aws_state_bucket"></a> [aws\_state\_bucket](#input\_aws\_state\_bucket) | S3 bucket name for storing OpenTofu state (also used for S3-native state locking). | `string` | `null` | no |
| <a name="input_aws_web_acl_name"></a> [aws\_web\_acl\_name](#input\_aws\_web\_acl\_name) | Name of an existing AWS WAF WebACL with scope=CLOUDFRONT. Only used when aws\_security = "waf". | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | static-files only. Cloud provider for this static-files scope configuration. | `string` | `null` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimension values for this configuration. | `map(string)` | `{}` | no |
| <a name="input_lambda_null_agent_layer_arn"></a> [lambda\_null\_agent\_layer\_arn](#input\_lambda\_null\_agent\_layer\_arn) | aws-lambda only. ARN of the nullplatform agent Lambda layer. Only needed when the scope sets USE\_NULL\_AGENT=true. | `string` | `null` | no |
| <a name="input_lambda_placeholder_image_uri"></a> [lambda\_placeholder\_image\_uri](#input\_lambda\_placeholder\_image\_uri) | aws-lambda only. ECR URI of the placeholder image, without the architecture suffix — the workflow appends -arm64 or -amd64 from the scope's architecture. | `string` | `null` | no |
| <a name="input_lambda_tofu_state_bucket"></a> [lambda\_tofu\_state\_bucket](#input\_lambda\_tofu\_state\_bucket) | aws-lambda only. S3 bucket where each Lambda scope writes its OpenTofu state. Scopes use distinct key prefixes, so one bucket can be shared. | `string` | `null` | no |
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
  "description": "Creates and manages a nullplatform provider scope configuration resource for either static-files (CloudFront/S3/Route53) or aws-lambda deployment types",
  "architecture": "The module creates a single nullplatform_provider_config resource, wiring the nrn, type, and dimensions inputs directly into it. The attributes payload is built by merging type-specific default maps with override maps computed in locals.tf — for static-files, cloud-provider-keyed overrides assemble distribution, network, security, and provider sub-objects; for aws-lambda, state and deployment objects are merged with an optional agent block when lambda_null_agent_layer_arn is provided. The final merged map is JSON-encoded and passed as the attributes argument, while the resource id is surfaced as the provider_config_id output.",
  "features": [
    "Creates a nullplatform_provider_config resource encoding provider-specific attributes as a JSON payload",
    "Configures static-files scope with CloudFront distribution, Route53 DNS, optional WAF WebACL attachment, and Lambda@Edge associations",
    "Configures aws-lambda scope with OpenTofu state bucket, ECR placeholder image URI, and optional nullplatform agent Lambda layer",
    "Merges provider-type defaults with caller-supplied overrides to prevent drift against unset optional fields",
    "Conditionally includes lambda_associations and agent blocks only when their inputs are non-empty, avoiding drift on configs that never declared them",
    "Validates each variable's applicability to the selected type and cloud provider to prevent misconfiguration"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (NRN) — unique identifier for the target resource.",
      "required": true
    },
    {
      "name": "type",
      "description": "Provider specification slug this scope configuration targets. Determines which set of variables below applies — see README for each type's payload.",
      "required": true
    },
    {
      "name": "cloud_provider",
      "description": "static-files only. Cloud provider for this static-files scope configuration.",
      "required": false
    },
    {
      "name": "aws_region",
      "description": "AWS region where resources will be deployed.",
      "required": false
    },
    {
      "name": "aws_state_bucket",
      "description": "S3 bucket name for storing OpenTofu state (also used for S3-native state locking).",
      "required": false
    },
    {
      "name": "aws_distribution",
      "description": "CDN distribution for serving static files.",
      "required": false
    },
    {
      "name": "aws_network",
      "description": "DNS provider for managing records.",
      "required": false
    },
    {
      "name": "aws_hosted_public_zone_id",
      "description": "Public hosted zone ID for DNS records (e.g., Z1234567890ABC).",
      "required": false
    },
    {
      "name": "aws_security",
      "description": "Optional WAF attachment for the CloudFront distribution. Choose 'none' to skip, or 'waf' to attach an existing AWS WAF WebACL.",
      "required": false
    },
    {
      "name": "aws_web_acl_name",
      "description": "Name of an existing AWS WAF WebACL with scope=CLOUDFRONT. Only used when aws_security = \\",
      "required": false
    },
    {
      "name": "aws_lambda_associations",
      "description": "Lambda@Edge functions attached to the CloudFront default cache behavior, one entry per CloudFront event. function_arn must include a published version. Empty (the default) leaves distribution.lambda_associations out of the payload, matching a spec that never declared it.",
      "required": false
    },
    {
      "name": "lambda_tofu_state_bucket",
      "description": "aws-lambda only. S3 bucket where each Lambda scope writes its OpenTofu state. Scopes use distinct key prefixes, so one bucket can be shared.",
      "required": false
    },
    {
      "name": "lambda_placeholder_image_uri",
      "description": "aws-lambda only. ECR URI of the placeholder image, without the architecture suffix — the workflow appends -arm64 or -amd64 from the scope's architecture.",
      "required": false
    },
    {
      "name": "lambda_null_agent_layer_arn",
      "description": "aws-lambda only. ARN of the nullplatform agent Lambda layer. Only needed when the scope sets USE_NULL_AGENT=true.",
      "required": false
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
  "hash": "885bdbf292f2722184b800974f0fb101"
}
END_AI_METADATA -->
