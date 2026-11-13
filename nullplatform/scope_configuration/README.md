# Module: scope_configuration

## Description

Creates and manages a nullplatform provider configuration (nullplatform_provider_config) for either static-files or aws-lambda scope types, encoding type-specific infrastructure settings as a JSON attributes payload

## Architecture

The module creates a single nullplatform_provider_config resource whose attributes field is populated by merging spec-schema-derived or built-in defaults with caller-supplied overrides, dispatched by var.type. For static-files, cloud-specific overrides (currently AWS only) are assembled from CloudFront distribution, Route53 network, WAF security, and S3 state variables and deep-merged with section defaults from local.static_files_defaults. For aws-lambda, state bucket and placeholder image URI are merged into deployment and state sections, with an optional agent block injected only when lambda_null_agent_layer_arn is provided. The final local.payload is JSON-encoded and written to the API via the nullplatform provider.

## Features

- Creates a nullplatform_provider_config resource encoding scope infrastructure settings as a versioned JSON payload
- Supports static-files scope type with CloudFront distribution, Route53 DNS, S3 state backend, and optional WAF WebACL configuration
- Supports aws-lambda scope type with S3 OpenTofu state bucket, ECR placeholder image URI, and optional nullplatform agent Lambda layer
- Merges built-in or spec-schema-derived section defaults with caller overrides using a one-level-deep merge strategy to prevent drift
- Translates legacy aws_lambda_associations format into the current aws_default_invocations spec format for backward compatibility
- Configures ordered CloudFront cache behaviors with per-behavior cache mode, compression, invocations, and response header policies
- Allows specification_slug override to target a renamed provider spec while keeping the type-driven payload shape

## Basic Usage

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v9.17.0"

  nrn  = "your-nrn"
  type = "your-type"
}
```

### Usage with Static Files Scope

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v9.17.0"

  aws_hosted_public_zone_id = "your-aws-hosted-public-zone-id"  # Required when type = "static-files"
  aws_region                = "your-aws-region"  # Required when type = "static-files"
  aws_state_bucket          = "your-aws-state-bucket"  # Required when type = "static-files"
  cloud_provider            = "your-cloud-provider"  # Required when type = "static-files"
  nrn                       = "your-nrn"
  type                      = "static-files"
}
```

### Usage with AWS Lambda Scope

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v9.17.0"

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
| <a name="input_aws_behaviors"></a> [aws\_behaviors](#input\_aws\_behaviors) | Ordered cache behaviors, each matching a path pattern. List order is the precedence CloudFront evaluates, and the first match wins, so put the most specific pattern first. Every field but path\_pattern mirrors its default\_* counterpart. | <pre>list(object({<br/>    path_pattern            = string<br/>    viewer_protocol_policy  = optional(string, "redirect-to-https")<br/>    compress                = optional(bool, true)<br/>    cache_mode              = optional(string, "legacy")<br/>    cache_policy            = optional(string, "CachingOptimized")<br/>    origin_request_policy   = optional(string, "AllViewerExceptHostHeader")<br/>    response_headers_policy = optional(string, "")<br/>    invocations = optional(list(object({<br/>      event_type   = string<br/>      function_arn = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_aws_custom_error_responses"></a> [aws\_custom\_error\_responses](#input\_aws\_custom\_error\_responses) | How CloudFront answers origin errors. A single-page app serves its entry document on 403 and 404 with response\_code 200, so the client router can take over. Empty creates none. | <pre>list(object({<br/>    error_code         = number<br/>    response_code      = optional(number)<br/>    response_page_path = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_aws_default_cache_mode"></a> [aws\_default\_cache\_mode](#input\_aws\_default\_cache\_mode) | Cache key and origin requests on the default cache behavior. "legacy" forwards nothing and caches for an hour; "policy" hands both over to the cache and origin request policies. | `string` | `"legacy"` | no |
| <a name="input_aws_default_cache_policy"></a> [aws\_default\_cache\_policy](#input\_aws\_default\_cache\_policy) | Managed cache policy for the default cache behavior. Only read when aws\_default\_cache\_mode = "policy". | `string` | `"CachingOptimized"` | no |
| <a name="input_aws_default_compress"></a> [aws\_default\_compress](#input\_aws\_default\_compress) | Let CloudFront gzip or brotli text responses on the default cache behavior when the viewer accepts it. | `bool` | `true` | no |
| <a name="input_aws_default_invocations"></a> [aws\_default\_invocations](#input\_aws\_default\_invocations) | Functions attached to the default cache behavior. A behavior runs CloudFront Functions or Lambda@Edge, never both, and Functions run on viewer events only. A Lambda ARN must include a published version. Supersedes aws\_lambda\_associations. | <pre>list(object({<br/>    event_type   = string<br/>    function_arn = string<br/>  }))</pre> | `[]` | no |
| <a name="input_aws_default_origin_request_policy"></a> [aws\_default\_origin\_request\_policy](#input\_aws\_default\_origin\_request\_policy) | Managed origin request policy for the default cache behavior. Only read when aws\_default\_cache\_mode = "policy". | `string` | `"AllViewerExceptHostHeader"` | no |
| <a name="input_aws_default_response_headers_policy"></a> [aws\_default\_response\_headers\_policy](#input\_aws\_default\_response\_headers\_policy) | Managed response headers policy for the default cache behavior. Empty attaches none. | `string` | `""` | no |
| <a name="input_aws_default_root_object"></a> [aws\_default\_root\_object](#input\_aws\_default\_root\_object) | Object returned when the request is for the site root. | `string` | `"index.html"` | no |
| <a name="input_aws_default_viewer_protocol_policy"></a> [aws\_default\_viewer\_protocol\_policy](#input\_aws\_default\_viewer\_protocol\_policy) | How CloudFront answers HTTP requests on the default cache behavior. | `string` | `"redirect-to-https"` | no |
| <a name="input_aws_distribution"></a> [aws\_distribution](#input\_aws\_distribution) | CDN distribution for serving static files. | `string` | `"cloudfront"` | no |
| <a name="input_aws_geo_restriction"></a> [aws\_geo\_restriction](#input\_aws\_geo\_restriction) | Countries allowed or denied, by ISO 3166-1 alpha-2 code. restriction\_type "none" serves everywhere and ignores locations. | <pre>object({<br/>    restriction_type = optional(string, "none")<br/>    locations        = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_aws_hosted_public_zone_id"></a> [aws\_hosted\_public\_zone\_id](#input\_aws\_hosted\_public\_zone\_id) | Public hosted zone ID for DNS records (e.g., Z1234567890ABC). | `string` | `null` | no |
| <a name="input_aws_lambda_associations"></a> [aws\_lambda\_associations](#input\_aws\_lambda\_associations) | Lambda@Edge functions attached to the CloudFront default cache behavior, one entry per CloudFront event. function\_arn must include a published version. Empty (the default) leaves distribution.lambda\_associations out of the payload, matching a spec that never declared it. | <pre>list(object({<br/>    event_type   = string<br/>    function_arn = string<br/>  }))</pre> | `[]` | no |
| <a name="input_aws_network"></a> [aws\_network](#input\_aws\_network) | DNS provider for managing records. | `string` | `"route53"` | no |
| <a name="input_aws_price_class"></a> [aws\_price\_class](#input\_aws\_price\_class) | Edge locations the distribution is served from. | `string` | `"PriceClass_100"` | no |
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
| <a name="input_spec_schema"></a> [spec\_schema](#input\_spec\_schema) | The `schema` object of the scope's scope-configuration spec (`module.scope_package_installation.scope_configuration_schema` or `module.scope_definition.scope_configuration.schema`). When set, it replaces the built-in defaults: top-level and section-field defaults are read for the keys and sections the module sends; deeper ones (e.g. inside array items) are not. Null keeps the built-in defaults. | `any` | `null` | no |
| <a name="input_specification_slug"></a> [specification\_slug](#input\_specification\_slug) | Slug of the provider specification the configuration targets, when it differs from `type` (a spec registered with a name override, e.g. `module.scope_package_installation.scope_configuration_specification_slug`). `type` still selects the payload shape. Defaults to `type`. | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | Scope type: selects which variables below apply and the payload shape (see README). Also the provider specification slug the configuration targets, unless `specification_slug` is set. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | ID of the created provider config. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_configuration",
  "description": "Creates and manages a nullplatform provider configuration (nullplatform_provider_config) for either static-files or aws-lambda scope types, encoding type-specific infrastructure settings as a JSON attributes payload",
  "architecture": "The module creates a single nullplatform_provider_config resource whose attributes field is populated by merging spec-schema-derived or built-in defaults with caller-supplied overrides, dispatched by var.type. For static-files, cloud-specific overrides (currently AWS only) are assembled from CloudFront distribution, Route53 network, WAF security, and S3 state variables and deep-merged with section defaults from local.static_files_defaults. For aws-lambda, state bucket and placeholder image URI are merged into deployment and state sections, with an optional agent block injected only when lambda_null_agent_layer_arn is provided. The final local.payload is JSON-encoded and written to the API via the nullplatform provider.",
  "features": [
    "Creates a nullplatform_provider_config resource encoding scope infrastructure settings as a versioned JSON payload",
    "Supports static-files scope type with CloudFront distribution, Route53 DNS, S3 state backend, and optional WAF WebACL configuration",
    "Supports aws-lambda scope type with S3 OpenTofu state bucket, ECR placeholder image URI, and optional nullplatform agent Lambda layer",
    "Merges built-in or spec-schema-derived section defaults with caller overrides using a one-level-deep merge strategy to prevent drift",
    "Translates legacy aws_lambda_associations format into the current aws_default_invocations spec format for backward compatibility",
    "Configures ordered CloudFront cache behaviors with per-behavior cache mode, compression, invocations, and response header policies",
    "Allows specification_slug override to target a renamed provider spec while keeping the type-driven payload shape"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (NRN) — unique identifier for the target resource.",
      "required": true
    },
    {
      "name": "type",
      "description": "Scope type: selects which variables below apply and the payload shape (see README). Also the provider specification slug the configuration targets, unless `specification_slug` is set.",
      "required": true
    },
    {
      "name": "specification_slug",
      "description": "Slug of the provider specification the configuration targets, when it differs from `type` (a spec registered with a name override, e.g. `module.scope_package_installation.scope_configuration_specification_slug`). `type` still selects the payload shape. Defaults to `type`.",
      "required": false
    },
    {
      "name": "spec_schema",
      "description": "",
      "required": false
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
      "name": "aws_default_viewer_protocol_policy",
      "description": "How CloudFront answers HTTP requests on the default cache behavior.",
      "required": false
    },
    {
      "name": "aws_default_invocations",
      "description": "Functions attached to the default cache behavior. A behavior runs CloudFront Functions or Lambda@Edge, never both, and Functions run on viewer events only. A Lambda ARN must include a published version. Supersedes aws_lambda_associations.",
      "required": false
    },
    {
      "name": "aws_default_cache_mode",
      "description": "Cache key and origin requests on the default cache behavior. \\",
      "required": false
    },
    {
      "name": "aws_default_cache_policy",
      "description": "Managed cache policy for the default cache behavior. Only read when aws_default_cache_mode = \\",
      "required": false
    },
    {
      "name": "aws_default_origin_request_policy",
      "description": "Managed origin request policy for the default cache behavior. Only read when aws_default_cache_mode = \\",
      "required": false
    },
    {
      "name": "aws_default_response_headers_policy",
      "description": "Managed response headers policy for the default cache behavior. Empty attaches none.",
      "required": false
    },
    {
      "name": "aws_behaviors",
      "description": "Ordered cache behaviors, each matching a path pattern. List order is the precedence CloudFront evaluates, and the first match wins, so put the most specific pattern first. Every field but path_pattern mirrors its default_* counterpart.",
      "required": false
    },
    {
      "name": "aws_custom_error_responses",
      "description": "How CloudFront answers origin errors. A single-page app serves its entry document on 403 and 404 with response_code 200, so the client router can take over. Empty creates none.",
      "required": false
    },
    {
      "name": "aws_price_class",
      "description": "Edge locations the distribution is served from.",
      "required": false
    },
    {
      "name": "aws_geo_restriction",
      "description": "Countries allowed or denied, by ISO 3166-1 alpha-2 code. restriction_type \\",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Dimension values for this configuration.",
      "required": false
    },
    {
      "name": "aws_default_compress",
      "description": "Let CloudFront gzip or brotli text responses on the default cache behavior when the viewer accepts it.",
      "required": false
    },
    {
      "name": "aws_default_root_object",
      "description": "Object returned when the request is for the site root.",
      "required": false
    }
  ],
  "outputs": [
    "provider_config_id"
  ],
  "hash": "51394d663a6518cfec5256c2ff0cf215"
}
END_AI_METADATA -->
