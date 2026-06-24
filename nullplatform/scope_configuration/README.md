# Module: scope_configuration

## Description

Creates a Nullplatform provider configuration resource with JSON-encoded attributes and optional dimensions

## Architecture

The module creates a single nullplatform_provider_config resource that associates a provider specification (identified by slug) with a target NRN. Input attributes are JSON-encoded and passed to the resource along with optional dimension mappings. The resource lifecycle is configured to ignore changes to attributes after initial creation. The provider configuration ID is exposed as an output for reference by dependent resources.

## Features

- Creates a Nullplatform provider configuration resource linked to a specific NRN
- JSON-encodes arbitrary configuration attributes matching provider specification schema
- Associates provider specification via slug identifier
- Supports optional dimension key-value mappings for scoped configurations
- Ignores attribute changes in lifecycle to prevent drift after initial deployment

## Basic Usage

```hcl
module "scope_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v4.5.2"

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
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Configuration attributes matching the provider specification schema. | `any` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimension values for this configuration. | `map(string)` | `{}` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (NRN) — unique identifier for the target resource. | `string` | n/a | yes |
| <a name="input_provider_specification_slug"></a> [provider\_specification\_slug](#input\_provider\_specification\_slug) | Slug of the provider specification (scope configuration type) to associate with. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | ID of the created provider config. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_configuration",
  "description": "Creates a Nullplatform provider configuration resource with JSON-encoded attributes and optional dimensions",
  "architecture": "The module creates a single nullplatform_provider_config resource that associates a provider specification (identified by slug) with a target NRN. Input attributes are JSON-encoded and passed to the resource along with optional dimension mappings. The resource lifecycle is configured to ignore changes to attributes after initial creation. The provider configuration ID is exposed as an output for reference by dependent resources.",
  "features": [
    "Creates a Nullplatform provider configuration resource linked to a specific NRN",
    "JSON-encodes arbitrary configuration attributes matching provider specification schema",
    "Associates provider specification via slug identifier",
    "Supports optional dimension key-value mappings for scoped configurations",
    "Ignores attribute changes in lifecycle to prevent drift after initial deployment"
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
      "name": "provider_specification_slug",
      "description": "Slug of the provider specification (scope configuration type) to associate with.",
      "required": true
    },
    {
      "name": "attributes",
      "description": "Configuration attributes matching the provider specification schema.",
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
  "hash": "78fb31d42df72b1ddeff84e1886f6c9c"
}
END_AI_METADATA -->
