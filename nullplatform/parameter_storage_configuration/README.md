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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_configuration?ref=v6.16.1"

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

## Supported Types

`type` selects the provider specification this configuration targets. Each type has its own payload and its own set of type-specific variables; adding a new type means adding it to the list below along with its variables.

### aws-secrets-manager (default)

| Variable | Maps to |
|----------|---------|
| `applies_to` | `sensibility.applies_to` |
| `kms_key_id` | `setup.kms_key_id` |

```hcl
module "parameter_storage_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_configuration?ref=vX.Y.Z"

  np_api_key = "your-np-api-key"
  nrn        = "your-nrn"
  type       = "aws-secrets-manager"

  applies_to = ["secret"]
  kms_key_id = "" # empty = default aws/secretsmanager managed key
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
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.96 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.parameter_store_configuration](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_applies_to"></a> [applies\_to](#input\_applies\_to) | aws-secrets-manager only. Resource types this parameter storage configuration applies to. | `list(string)` | <pre>[<br/>  "secret"<br/>]</pre> | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimension values for this instance (e.g. { environment = "production" }). | `map(string)` | `{}` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | aws-secrets-manager only. Customer-managed KMS key ARN or alias. If empty, the default aws/secretsmanager managed key is used. | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where this parameter-storage instance (provider config) is anchored. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Provider specification slug this configuration targets. Determines which default attribute shape is applied — see README for the supported types and their payloads. | `string` | n/a | yes |

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
