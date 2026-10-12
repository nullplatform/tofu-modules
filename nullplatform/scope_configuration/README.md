# Module: scope_configuration

## Description

Creates and manages a nullplatform provider scope configuration resource for either static-files (CloudFront-based CDN) or aws-lambda deployments, encoding type-specific attributes as a JSON payload

## Architecture

The module defines a single nullplatform_provider_config.scope_configuration resource that receives a jsonencode()-merged attributes payload built from local.defaults and local.overrides computed in locals.tf. For static-files, locals assemble a nested map covering cloud_provider, provider (aws_region, aws_state_bucket), distribution (CloudFront settings, cache behaviors, invocations), network (Route53 zone), and security (WAF) blocks, dispatching per cloud via static_files_cloud_overrides. For aws-lambda, locals build a flat map with state.tofu_state_bucket, deployment.placeholder_image_uri, and an optional agent.null_agent_layer_arn block, then merge both paths through a type_defaults/type_overrides dispatch table keyed on var.type.

## Features

- Creates a nullplatform_provider_config resource with type-dispatched JSON attributes for static-files or aws-lambda scope configurations
- Configures CloudFront distribution settings including cache behaviors, viewer protocol policies, Lambda@Edge and CloudFront Function invocations, and geo-restriction rules
- Supports WAF WebACL attachment to CloudFront distributions via aws_security and aws_web_acl_name variables
- Manages Route53 DNS integration with a configurable public hosted zone for static-files deployments
- Configures AWS Lambda scope state bucket, placeholder ECR image URI, and optional nullplatform agent Lambda layer ARN
- Translates legacy aws_lambda_associations into the current distribution.default_invocations spec format to preserve backward compatibility
- Outputs the created provider config ID for downstream module consumption

## Basic Usage

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v8.5.0"

  nrn  = "your-nrn"
  type = "your-type"
}
```

### Usage with Static Files

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v8.5.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v8.5.0"

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
| <a name="input_type"></a> [type](#input\_type) | Provider specification slug this scope configuration targets. Determines which set of variables below applies — see README for each type's payload. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | ID of the created provider config. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_configuration",
  "description": "Creates and manages a nullplatform provider scope configuration resource for either static-files (CloudFront-based CDN) or aws-lambda deployments, encoding type-specific attributes as a JSON payload",
  "architecture": "The module defines a single nullplatform_provider_config.scope_configuration resource that receives a jsonencode()-merged attributes payload built from local.defaults and local.overrides computed in locals.tf. For static-files, locals assemble a nested map covering cloud_provider, provider (aws_region, aws_state_bucket), distribution (CloudFront settings, cache behaviors, invocations), network (Route53 zone), and security (WAF) blocks, dispatching per cloud via static_files_cloud_overrides. For aws-lambda, locals build a flat map with state.tofu_state_bucket, deployment.placeholder_image_uri, and an optional agent.null_agent_layer_arn block, then merge both paths through a type_defaults/type_overrides dispatch table keyed on var.type.",
  "features": [
    "Creates a nullplatform_provider_config resource with type-dispatched JSON attributes for static-files or aws-lambda scope configurations",
    "Configures CloudFront distribution settings including cache behaviors, viewer protocol policies, Lambda@Edge and CloudFront Function invocations, and geo-restriction rules",
    "Supports WAF WebACL attachment to CloudFront distributions via aws_security and aws_web_acl_name variables",
    "Manages Route53 DNS integration with a configurable public hosted zone for static-files deployments",
    "Configures AWS Lambda scope state bucket, placeholder ECR image URI, and optional nullplatform agent Lambda layer ARN",
    "Translates legacy aws_lambda_associations into the current distribution.default_invocations spec format to preserve backward compatibility",
    "Outputs the created provider config ID for downstream module consumption"
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
  "hash": "3cebd60b77c09ad2fad731d7a4038335"
}
END_AI_METADATA -->
