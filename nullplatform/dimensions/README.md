# Module: dimensions

## Description

Creates Nullplatform dimension and dimension values for environment management

## Architecture

The module creates a nullplatform_dimension resource named 'Environment' with order 1, then creates nullplatform_dimension_value resources for each environment specified in the environments list. The dimension is linked to the provided NRN, and each dimension value is associated with the created dimension through its dimension_id.

## Features

- Creates environment dimension with configurable ordering
- Generates dimension values for each specified environment
- Supports custom environment names beyond the default set

## Basic Usage

```hcl
module "dimensions" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimensions?ref=v1.48.1"

  np_api_key = "your-np-api-key"
  nrn        = "your-nrn"
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
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name (NRN) | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "dimensions",
  "description": "Creates Nullplatform dimension and dimension values for environment management",
  "architecture": "The module creates a nullplatform_dimension resource named 'Environment' with order 1, then creates nullplatform_dimension_value resources for each environment specified in the environments list. The dimension is linked to the provided NRN, and each dimension value is associated with the created dimension through its dimension_id.",
  "features": [
    "Creates environment dimension with configurable ordering",
    "Generates dimension values for each specified environment",
    "Supports custom environment names beyond the default set"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Identifier Nullplatform Resources Name (NRN)",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "Nullplatform API key for authentication",
      "required": true
    },
    {
      "name": "environments",
      "description": "The list of environments",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "eca98722933c67fbb1b3d43a67952bd8"
}
END_AI_METADATA -->
