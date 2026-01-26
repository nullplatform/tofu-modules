# Module: Authorization

This module provisions a nullplatform API key for the specified destination and automatically assigns the following roles:
**agent**, **developer**, **ops**, **secops**, and **secrets-reader**.
Usage:

## Usage

### Basic example

```hcl
module "authorization" {
  source      = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/authorization?ref=v1.24.0"
  nrn         = var.nrn
  destination = var.destination
  np_api_key  = var.np_api_key
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_key"></a> [api\_key](#module\_api\_key) | git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key | main |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination"></a> [destination](#input\_destination) | The name of the resource to use | `string` | n/a | yes |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_authorization_api_key"></a> [authorization\_api\_key](#output\_authorization\_api\_key) | n/a |
<!-- END_TF_DOCS -->
