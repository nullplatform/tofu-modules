# Module: dimensions

## Description

Creates and manages a Nullplatform Environment dimension with configurable environment values

## Features

- Creates a Nullplatform dimension for organizing environments
- Configures environment values from a customizable list
- Supports multiple environments including development, staging, and production
- Manages dimension ordering for consistent hierarchy
- Integrates with Nullplatform resource naming (NRN) system

## Basic Usage

```hcl
module "dimensions" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimensions?ref=v1.39.0"

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
