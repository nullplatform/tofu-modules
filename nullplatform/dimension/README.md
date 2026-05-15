# Module: dimension

## Description

Creates a single Nullplatform dimension with a configurable name, order, and list of allowed values.

Each `module` instance creates exactly one dimension. To declare multiple dimensions (e.g. `Environment` and `Region`), instantiate this module once per dimension.

## Architecture

This module provisions a `nullplatform_dimension` resource with the supplied `name` and `order`. It then creates one `nullplatform_dimension_value` resource per entry in `var.values` via `for_each`, each linked to the parent dimension through `dimension_id`. The `nrn` input flows into both resources to anchor them in the Nullplatform resource hierarchy.

## Basic Usage

```hcl
module "environment_dimension" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimension?ref=v2.6.0"

  nrn    = "organization=1234:account=5678"
  name   = "Environment"
  order  = 1
  values = ["development", "staging", "production"]
}

module "region_dimension" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimension?ref=v2.6.0"

  nrn    = "organization=1234:account=5678"
  name   = "Region"
  order  = 2
  values = ["us-east-1", "sa-east-1"]
}
```

## Inputs

| Name     | Description                                                       | Type           | Default | Required |
|----------|-------------------------------------------------------------------|----------------|---------|----------|
| `nrn`    | Identifier Nullplatform Resources Name (NRN)                      | `string`       | n/a     | yes      |
| `name`   | Display name of the dimension (e.g. `Environment`, `Region`)      | `string`       | n/a     | yes      |
| `order`  | Display order of the dimension                                    | `number`       | `1`     | no       |
| `values` | List of valid values for this dimension                           | `list(string)` | `[]`    | no       |

## Migration from the `dimensions` module

This module replaces the previous `nullplatform/dimensions` module. The old module was hardcoded to create a single dimension named `Environment` and accepted only the value list through `var.environments`.

To migrate, replace each invocation of `dimensions` with `dimension` and translate the variables:

```diff
-module "dimensions" {
-  source       = ".../nullplatform/dimensions?ref=v2.5.1"
-  nrn          = var.nrn
-  environments = ["development", "staging", "production"]
-}
+module "environment_dimension" {
+  source = ".../nullplatform/dimension?ref=v2.6.0"
+  nrn    = var.nrn
+  name   = "Environment"
+  values = ["development", "staging", "production"]
+}
```

Because the internal resource labels changed (`nullplatform_dimension.environment` → `nullplatform_dimension.this`), the state must be moved before the next apply to avoid Terraform recreating the dimension:

```bash
terraform state mv \
  'module.dimensions.nullplatform_dimension.environment' \
  'module.environment_dimension.nullplatform_dimension.this'

for env in development staging production; do
  terraform state mv \
    "module.dimensions.nullplatform_dimension_value.environment_value[\"$env\"]" \
    "module.environment_dimension.nullplatform_dimension_value.this[\"$env\"]"
done
```
