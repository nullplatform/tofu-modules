# Module: parameter_storage_configuration

## Description

Provisions a nullplatform parameter-storage provider configuration instance by wrapping the scope_configuration module with a validated provider specification slug

## Architecture

The module delegates entirely to a remote `scope_configuration` module sourced from the nullplatform tofu-modules repository. Input variables `nrn`, `np_api_key`, `provider_specification_slug`, `dimensions`, and `attributes` are forwarded directly into that child module. The child module creates a nullplatform provider config resource anchored to the given NRN and associated with the specified provider specification. The resulting `provider_config_id` is surfaced as an output from the child module back to the caller.

## Features

- Creates a nullplatform parameter-storage provider configuration instance anchored to a specified NRN
- Validates that provider_specification_slug is non-empty before provisioning
- Forwards provider-specific attributes matching the provider specification schema to the underlying scope_configuration module
- Supports dimension-based scoping via a configurable map of dimension key-value pairs
- Exposes the created provider config ID as an output for downstream module consumption

## Basic Usage

```hcl
module "parameter_storage_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_configuration?ref=v6.6.0"

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
  example_attribute = module.parameter_storage_configuration.provider_config_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_config"></a> [config](#module\_config) | git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration | v6.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Provider-specific configuration matching the provider specification schema (e.g. sensibility.applies\_to, setup.kms\_key\_id). | `any` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimension values for this instance (e.g. { environment = "production" }). | `map(string)` | `{}` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key. Forwarded to the wrapped scope\_configuration module; the provider is configured at the root. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where this parameter-storage instance (provider config) is anchored. | `string` | n/a | yes |
| <a name="input_provider_specification_slug"></a> [provider\_specification\_slug](#input\_provider\_specification\_slug) | Slug of the parameter-storage provider specification to associate with. Typically the `slug` output of the parameter\_storage\_definition module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | ID of the created provider config (parameter-storage instance). |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "parameter_storage_configuration",
  "description": "Provisions a nullplatform parameter-storage provider configuration instance by wrapping the scope_configuration module with a validated provider specification slug",
  "architecture": "The module delegates entirely to a remote `scope_configuration` module sourced from the nullplatform tofu-modules repository. Input variables `nrn`, `np_api_key`, `provider_specification_slug`, `dimensions`, and `attributes` are forwarded directly into that child module. The child module creates a nullplatform provider config resource anchored to the given NRN and associated with the specified provider specification. The resulting `provider_config_id` is surfaced as an output from the child module back to the caller.",
  "features": [
    "Creates a nullplatform parameter-storage provider configuration instance anchored to a specified NRN",
    "Validates that provider_specification_slug is non-empty before provisioning",
    "Forwards provider-specific attributes matching the provider specification schema to the underlying scope_configuration module",
    "Supports dimension-based scoping via a configurable map of dimension key-value pairs",
    "Exposes the created provider config ID as an output for downstream module consumption"
  ],
  "inputs": [
    {
      "name": "np_api_key",
      "description": "nullplatform API key. Forwarded to the wrapped scope_configuration module; the provider is configured at the root.",
      "required": true
    },
    {
      "name": "nrn",
      "description": "NRN where this parameter-storage instance (provider config) is anchored.",
      "required": true
    },
    {
      "name": "attributes",
      "description": "Provider-specific configuration matching the provider specification schema (e.g. sensibility.applies_to, setup.kms_key_id).",
      "required": true
    },
    {
      "name": "provider_specification_slug",
      "description": "Slug of the parameter-storage provider specification to associate with. Typically the `slug` output of the parameter_storage_definition module.",
      "required": true
    },
    {
      "name": "dimensions",
      "description": "Dimension values for this instance (e.g. { environment = \\",
      "required": false
    }
  ],
  "outputs": [
    "provider_config_id"
  ],
  "hash": "c1c5d0629292f004340d1feb4dd1931c"
}
END_AI_METADATA -->
