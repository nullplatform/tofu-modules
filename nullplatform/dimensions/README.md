# Module: dimensions

## Description

Creates a Nullplatform dimension for environments with configurable dimension values

## Architecture

This module provisions a nullplatform_dimension resource representing an environment dimension with a fixed order of 1. It then creates multiple nullplatform_dimension_value resources using for_each iteration over the environments list, where each value is associated with the parent dimension via dimension_id. The nrn input flows into both the dimension and dimension value resources to establish the Nullplatform resource hierarchy.

## Features

- Creates a Nullplatform dimension resource named 'Environment' with configurable ordering
- Generates dimension values dynamically from a configurable list of environment names
- Associates all dimension values with the parent dimension through dimension_id linkage
- Supports custom environment lists including development, staging, and production by default
- Links all resources to a Nullplatform organization through the NRN identifier

## Basic Usage

```hcl
module "dimensions" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimensions?ref=v1.52.0"

  nrn = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dimensions.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_dimension.environment](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/dimension) | resource |
| [nullplatform_dimension_value.environment_value](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/dimension_value) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environments"></a> [environments](#input\_environments) | The list of environments | `list(string)` | <pre>[<br/>  "development",<br/>  "staging",<br/>  "production"<br/>]</pre> | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name (NRN) | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "dimensions",
  "description": "Creates a Nullplatform dimension for environments with configurable dimension values",
  "architecture": "This module provisions a nullplatform_dimension resource representing an environment dimension with a fixed order of 1. It then creates multiple nullplatform_dimension_value resources using for_each iteration over the environments list, where each value is associated with the parent dimension via dimension_id. The nrn input flows into both the dimension and dimension value resources to establish the Nullplatform resource hierarchy.",
  "features": [
    "Creates a Nullplatform dimension resource named 'Environment' with configurable ordering",
    "Generates dimension values dynamically from a configurable list of environment names",
    "Associates all dimension values with the parent dimension through dimension_id linkage",
    "Supports custom environment lists including development, staging, and production by default",
    "Links all resources to a Nullplatform organization through the NRN identifier"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Identifier Nullplatform Resources Name (NRN)",
      "required": true
    },
    {
      "name": "environments",
      "description": "The list of environments",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "d6b86979ceeaba18550f4966bf233b20"
}
END_AI_METADATA -->
