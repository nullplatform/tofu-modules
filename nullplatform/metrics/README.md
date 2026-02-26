# Module: metrics

## Description

Configures Prometheus as a provider in Nullplatform with customizable server URL and Kubernetes namespace settings

## Features

- Creates a Nullplatform provider configuration for Prometheus monitoring
- Supports custom Prometheus server URL or auto-generates URL based on Kubernetes service
- Configures Prometheus server connection with configurable namespace
- Manages provider dimensions for resource organization
- Ignores attribute changes in lifecycle to prevent configuration drift

## Basic Usage

```hcl
module "metrics" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/metrics?ref=v1.38.3"

  np_api_key = "your-np-api-key"
  nrn        = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.metrics.id
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
| [nullplatform_provider_config.prometheus](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | name of the dimensions | `map` | `{}` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | nullplatform Resource Name — unique identifier for resources | `string` | n/a | yes |
| <a name="input_prometheus_namespace"></a> [prometheus\_namespace](#input\_prometheus\_namespace) | Kubernetes namespace where Prometheus will be deployed | `string` | `"prometheus"` | no |
| <a name="input_prometheus_url"></a> [prometheus\_url](#input\_prometheus\_url) | n/a | `string` | `""` | no |
<!-- END_TF_DOCS -->
