# Module: dimension_value

## Description

Creates nullplatform dimension values across one or more NRNs (Null Resource Names) for a given parent dimension

## Architecture

The module uses a terraform_data resource to enforce mutual-exclusivity and presence preconditions on the nrn/nrns inputs before any dimension values are created. A local value resolves the effective list of NRNs from either the singular nrn or the nrns list input. The nullplatform_dimension_value resource is then instantiated via for_each over that resolved NRN set, binding each instance to the shared dimension_id and name inputs. Outputs expose maps of NRN-to-ID and NRN-to-slug for downstream consumption.

## Features

- Creates one nullplatform_dimension_value resource per NRN using for_each iteration
- Supports both single-NRN and multi-NRN input patterns via mutually exclusive nrn and nrns variables
- Enforces input mutual-exclusivity and presence validation via terraform_data lifecycle preconditions
- Outputs NRN-keyed maps of dimension value IDs and slugs for downstream module composition

## Basic Usage

```hcl
module "dimension_value" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimension_value?ref=v5.2.0"

  dimension_id = "your-dimension-id"
  name         = "your-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dimension_value.ids
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
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_dimension_value.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/dimension_value) | resource |
| [terraform_data.validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimension_id"></a> [dimension\_id](#input\_dimension\_id) | ID of the parent dimension this value belongs to. Typically the `id` output of a `dimension` module instance. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the dimension value. The same name is applied to every NRN. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Single NRN where this dimension value should be created. Use this for one NRN. Mutually exclusive with `nrns`. | `string` | `null` | no |
| <a name="input_nrns"></a> [nrns](#input\_nrns) | List of NRNs where this dimension value should be created (one resource per NRN). Use this for multiple NRNs. Mutually exclusive with `nrn`. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ids"></a> [ids](#output\_ids) | Map of NRN to created dimension value ID. |
| <a name="output_slugs"></a> [slugs](#output\_slugs) | Map of NRN to created dimension value slug. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "dimension_value",
  "description": "Creates nullplatform dimension values across one or more NRNs (Null Resource Names) for a given parent dimension",
  "architecture": "The module uses a terraform_data resource to enforce mutual-exclusivity and presence preconditions on the nrn/nrns inputs before any dimension values are created. A local value resolves the effective list of NRNs from either the singular nrn or the nrns list input. The nullplatform_dimension_value resource is then instantiated via for_each over that resolved NRN set, binding each instance to the shared dimension_id and name inputs. Outputs expose maps of NRN-to-ID and NRN-to-slug for downstream consumption.",
  "features": [
    "Creates one nullplatform_dimension_value resource per NRN using for_each iteration",
    "Supports both single-NRN and multi-NRN input patterns via mutually exclusive nrn and nrns variables",
    "Enforces input mutual-exclusivity and presence validation via terraform_data lifecycle preconditions",
    "Outputs NRN-keyed maps of dimension value IDs and slugs for downstream module composition"
  ],
  "inputs": [
    {
      "name": "dimension_id",
      "description": "ID of the parent dimension this value belongs to. Typically the `id` output of a `dimension` module instance.",
      "required": true
    },
    {
      "name": "name",
      "description": "Name of the dimension value. The same name is applied to every NRN.",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Single NRN where this dimension value should be created. Use this for one NRN. Mutually exclusive with `nrns`.",
      "required": false
    },
    {
      "name": "nrns",
      "description": "List of NRNs where this dimension value should be created (one resource per NRN). Use this for multiple NRNs. Mutually exclusive with `nrn`.",
      "required": false
    }
  ],
  "outputs": [
    "ids",
    "slugs"
  ],
  "hash": "225f86e26959a50cdde435c24eff6b18"
}
END_AI_METADATA -->
