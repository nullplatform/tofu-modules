# Module: metrics

## Description

Configures a Prometheus provider in nullplatform with customizable server URL and namespace settings

## Features

- Creates a nullplatform provider configuration for Prometheus integration
- Supports custom Prometheus server URL or auto-generates URL from namespace
- Configures Prometheus server connection with customizable dimensions
- Manages provider configuration lifecycle with attribute change ignoring
- Defaults to Prometheus server in prometheus namespace if URL not specified
- Enables flexible dimension-based resource organization

## Basic Usage

```hcl
module "metrics" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/metrics?ref=v1.38.2"

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
