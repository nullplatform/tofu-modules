# Module: dimension_value

## Description

Adds one or more dimension values to an existing Nullplatform dimension, each scoped to its own NRN. The same value `name` (e.g. `"OCI"`) can be applied either to a single NRN (via `var.nrn`) or to multiple NRNs in a single module call (via `var.nrns`).

This module is typically used as a sibling of the `nullplatform/dimension` module:

1. `dimension` creates the parent dimension at one NRN level (e.g. account).
2. `dimension_value` attaches additional values that live at narrower NRN levels (e.g. namespace, application), referencing the parent via its `id` output.

## Architecture

The module accepts either `var.nrn` (single string) or `var.nrns` (list of strings), normalizes both into a single list internally, and declares a `nullplatform_dimension_value` resource per NRN with `for_each`. The set key in state is the NRN itself. Preconditions enforce that exactly one of the two inputs is provided.

## Basic Usage

### Single NRN

```hcl
module "dimension_environment" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimension?ref=v2.6.0"

  nrn    = "organization=1698562351:account=1372325109"
  name   = "Environment"
  order  = 1
  values = ["development", "staging", "production"]
}

module "dimension_value_environment_oci" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimension_value?ref=v2.6.0"

  dimension_id = module.dimension_environment.id
  name         = "OCI"
  nrn          = "organization=1698562351:account=1372325109:namespace=956240080"
}
```

### Multiple NRNs

```hcl
module "dimension_value_environment_oci" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimension_value?ref=v2.6.0"

  dimension_id = module.dimension_environment.id
  name         = "OCI"
  nrns = [
    "organization=1698562351:account=1372325109:namespace=956240080",
    "organization=1698562351:account=1372325109:namespace=999999999",
  ]
}
```

## Inputs

| Name           | Description                                                                                                  | Type           | Default | Required |
|----------------|--------------------------------------------------------------------------------------------------------------|----------------|---------|----------|
| `dimension_id` | ID of the parent dimension. Typically the `id` output of a `dimension` module instance.                      | `number`       | n/a     | yes      |
| `name`         | Name of the dimension value. The same name is applied to every NRN.                                          | `string`       | n/a     | yes      |
| `nrn`          | Single NRN where this dimension value should be created. Mutually exclusive with `nrns`.                     | `string`       | `null`  | one of the two |
| `nrns`         | List of NRNs where this dimension value should be created (one resource per NRN). Mutually exclusive with `nrn`. | `list(string)` | `[]`    | one of the two |

A `precondition` enforces that exactly one of `nrn` / `nrns` is provided.

## Outputs

| Name    | Description                                |
|---------|--------------------------------------------|
| `ids`   | Map of NRN to created dimension value ID.  |
| `slugs` | Map of NRN to created dimension value slug.|
