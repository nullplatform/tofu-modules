# Module: scope_configuration

## Description

Creates a Nullplatform provider configuration for a scope definition, linking a provider specification (identified by slug) with concrete attribute values such as cloud provider, region, state backend, distribution, and network settings.

## Architecture

The module creates a single `nullplatform_provider_config` resource that associates a provider specification (e.g., "static-files") with a target NRN. The `type` field receives the provider specification slug, and `attributes` contains the JSON-encoded configuration values that match the specification's schema. Dimensions can optionally be provided to scope the configuration to specific environments or other dimension values.

## Features

- Creates provider configurations for any scope definition that exposes a provider specification
- Supports arbitrary attribute schemas defined by the provider specification
- Optional dimension support for environment-specific configurations
- Uses `ignore_changes` on attributes to prevent drift after initial creation

## Basic Usage

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v1.48.3"

  nrn                         = "organization=123:account=456"
  np_api_key                  = var.np_api_key
  provider_specification_slug = module.scope_definition.provider_specification_slug
  attributes = {
    cloud_provider = "aws"
  }
}
```

### Usage with AWS Static Files

```hcl
module "scope_configuration_static_scope" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v1.48.3"

  nrn                         = var.nrn
  np_api_key                  = var.np_api_key
  provider_specification_slug = module.scope_definition_static_scope.provider_specification_slug
  attributes = {
    cloud_provider = "aws"
    provider = {
      aws_region       = "us-east-1"
      aws_state_bucket = "my-tfstate-bucket"
    }
    distribution = {
      aws_distribution = "cloudfront"
    }
    network = {
      aws_network               = "route53"
      aws_hosted_public_zone_id = "Z0123456789ABC"
    }
  }
}
```

### Usage with Dimensions

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v1.48.3"

  nrn                         = var.nrn
  np_api_key                  = var.np_api_key
  provider_specification_slug = module.scope_definition.provider_specification_slug
  dimensions = {
    environment = "production"
  }
  attributes = {
    cloud_provider = "aws"
    provider = {
      aws_region       = "eu-west-1"
      aws_state_bucket = "prod-tfstate-bucket"
    }
  }
}
```

## Using Outputs

```hcl
# Reference the provider config ID in other resources
resource "example_resource" "this" {
  provider_config_id = module.scope_configuration.provider_config_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.67 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.67 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.scope_configuration](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (NRN) — unique identifier for the target resource. | `string` | n/a | yes |
| <a name="input_provider_specification_slug"></a> [provider\_specification\_slug](#input\_provider\_specification\_slug) | Slug of the provider specification (scope configuration type) to associate with. | `string` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Configuration attributes matching the provider specification schema. | `any` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimension values for this configuration. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | ID of the created provider config. |
<!-- END_TF_DOCS -->
