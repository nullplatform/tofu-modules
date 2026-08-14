# Module: dimension

## Description

Creates a Nullplatform dimension with optional predefined values for organizing and categorizing resources within a given NRN scope

## Architecture

The module creates a nullplatform_dimension resource using the provided name, order, and NRN inputs to define a categorization axis. For each entry in the values list, a nullplatform_dimension_value resource is created via for_each, referencing the parent dimension's ID to associate values with it. The dimension ID, slug, and NRN are exposed as outputs to allow downstream modules or resources to reference the created dimension.

## Features

- Creates a nullplatform_dimension resource with configurable display name and sort order
- Provisions multiple nullplatform_dimension_value resources dynamically from a list of string values
- Links each dimension value to its parent dimension using the generated dimension ID
- Outputs the dimension ID, slug, and NRN for use in downstream module compositions

## Basic Usage

```hcl
module "dimension" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimension?ref=v6.16.1"

  name = "your-name"
  nrn  = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dimension.id
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
| [nullplatform_dimension.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/dimension) | resource |
| [nullplatform_dimension_value.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/dimension_value) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Display name of the dimension (e.g. 'Environment', 'Region') | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name (NRN) | `string` | n/a | yes |
| <a name="input_order"></a> [order](#input\_order) | Display order of the dimension | `number` | `1` | no |
| <a name="input_values"></a> [values](#input\_values) | List of valid values for this dimension | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created dimension. Use this to attach additional dimension values from a `dimension_value` module instance. |
| <a name="output_nrn"></a> [nrn](#output\_nrn) | The NRN where the dimension was created. |
| <a name="output_slug"></a> [slug](#output\_slug) | The slug of the created dimension. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "dimension",
  "description": "Creates a Nullplatform dimension with optional predefined values for organizing and categorizing resources within a given NRN scope",
  "architecture": "The module creates a nullplatform_dimension resource using the provided name, order, and NRN inputs to define a categorization axis. For each entry in the values list, a nullplatform_dimension_value resource is created via for_each, referencing the parent dimension's ID to associate values with it. The dimension ID, slug, and NRN are exposed as outputs to allow downstream modules or resources to reference the created dimension.",
  "features": [
    "Creates a nullplatform_dimension resource with configurable display name and sort order",
    "Provisions multiple nullplatform_dimension_value resources dynamically from a list of string values",
    "Links each dimension value to its parent dimension using the generated dimension ID",
    "Outputs the dimension ID, slug, and NRN for use in downstream module compositions"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Identifier Nullplatform Resources Name (NRN)",
      "required": true
    },
    {
      "name": "name",
      "description": "Display name of the dimension (e.g. 'Environment', 'Region')",
      "required": true
    },
    {
      "name": "order",
      "description": "Display order of the dimension",
      "required": false
    },
    {
      "name": "values",
      "description": "List of valid values for this dimension",
      "required": false
    }
  ],
  "outputs": [
    "id",
    "slug",
    "nrn"
  ],
  "hash": "5458060b7a0e0d8efd9ecc32eab8d197"
}
END_AI_METADATA -->
