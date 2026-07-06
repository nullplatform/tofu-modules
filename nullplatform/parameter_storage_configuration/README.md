# Module: parameter_storage_configuration

## Description

Registers a single parameter-storage provider instance (a `nullplatform_provider_config`) against an NRN and dimensions, by wrapping the scope_configuration module. Designed to be instantiated with `for_each` by the caller, one per instance

## Architecture

The module is a thin, parameter-storage-flavored wrapper around the shared `scope_configuration` module (pinned to a fixed git ref). It forwards the NRN, API key, provider specification slug, dimensions, and the provider-specific `attributes` object to that module, which creates the underlying `nullplatform_provider_config`. Modeling a single instance keeps the module focused: the caller supplies the specification slug (typically the `slug` output of `parameter_storage_definition`) and drives multiplicity with its own `for_each`, so each instance is an independent addressable resource.

## Features

- Registers one parameter-storage provider instance per module invocation
- Wraps the shared scope_configuration module so the provider_config logic lives in a single place
- Forwards a provider-specific `attributes` object unchanged, so each caller matches its own provider schema (e.g. Parameter Store sends setup.tier, Secrets Manager omits it)
- Validates that `provider_specification_slug` is non-empty before attempting registration
- Exposes the created provider config ID for downstream references

## Basic Usage

```hcl
# The specification (created once) and the instances (one per NRN/dimension set)
# are separate modules. The caller wires the spec's slug into each instance and
# drives multiplicity with for_each.

module "parameter_storage_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition?ref=v6.1.0"

  np_api_key            = var.np_api_key
  nrn                   = "organization=1"
  template_path         = "parameters/providers/aws-secrets-manager/specs/install/aws-secrets-manager-configuration.json.tpl"
  extra_visible_to_nrns = [for i in local.instances : i.nrn]
}

module "parameter_storage_configuration" {
  source   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_configuration?ref=v6.1.0"
  for_each = local.instances

  np_api_key                  = var.np_api_key
  nrn                         = each.value.nrn
  provider_specification_slug = module.parameter_storage_definition.slug
  dimensions                  = each.value.dimensions
  attributes                  = each.value.attributes
}
```

Where the caller defines the instances, for example:

```hcl
locals {
  instances = {
    prod = {
      nrn        = "organization=1:account=2:namespace=3"
      dimensions = { environment = "production" }
      attributes = {
        sensibility = { applies_to = ["secret"] }
        setup       = { kms_key_id = "" }
      }
    }
  }
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.parameter_storage_configuration["prod"].provider_config_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_config"></a> [config](#module\_config) | git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration | v6.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key for authentication. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where this parameter-storage instance (provider config) is anchored. | `string` | n/a | yes |
| <a name="input_provider_specification_slug"></a> [provider\_specification\_slug](#input\_provider\_specification\_slug) | Slug of the parameter-storage provider specification to associate with. Typically the `slug` output of the parameter\_storage\_definition module. | `string` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Provider-specific configuration matching the provider specification schema (e.g. sensibility.applies\_to, setup.kms\_key\_id). | `any` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimension values for this instance (e.g. { environment = "production" }). | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | ID of the created provider config (parameter-storage instance). |
<!-- END_TF_DOCS -->
