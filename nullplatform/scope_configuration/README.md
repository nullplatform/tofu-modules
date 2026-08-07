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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v6.11.0"

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
