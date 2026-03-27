# Module: metrics

## Description

Configures a Prometheus provider in the Nullplatform with server URL and dimensions

## Architecture

The module creates a single nullplatform_provider_config resource of type prometheus, wiring the computed prometheus_server_url from locals into its attributes. Inputs flow through var.prometheus_url and var.prometheus_namespace to build the server URL, while var.nrn and var.np_api_key authenticate and scope the provider configuration. Outputs are not exposed; the resource is marked to ignore future attribute changes.

## Features

- Creates a Prometheus provider configuration in Nullplatform
- Derives server URL from optional custom URL or namespace-based service DNS
- Attaches dimension metadata to the provider for filtering and grouping

## Basic Usage

```hcl
module "metrics" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/metrics?ref=v1.48.2"

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

<!-- BEGIN_AI_METADATA
{
  "name": "metrics",
  "description": "Configures a Prometheus provider in the Nullplatform with server URL and dimensions",
  "architecture": "The module creates a single nullplatform_provider_config resource of type prometheus, wiring the computed prometheus_server_url from locals into its attributes. Inputs flow through var.prometheus_url and var.prometheus_namespace to build the server URL, while var.nrn and var.np_api_key authenticate and scope the provider configuration. Outputs are not exposed; the resource is marked to ignore future attribute changes.",
  "features": [
    "Creates a Prometheus provider configuration in Nullplatform",
    "Derives server URL from optional custom URL or namespace-based service DNS",
    "Attaches dimension metadata to the provider for filtering and grouping"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "nullplatform Resource Name — unique identifier for resources",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "nullplatform API key for authentication",
      "required": true
    },
    {
      "name": "prometheus_url",
      "description": "",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "name of the dimensions",
      "required": false
    },
    {
      "name": "prometheus_namespace",
      "description": "Kubernetes namespace where Prometheus will be deployed",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "0fb52160b3f6655113caba2acb7dac2a"
}
END_AI_METADATA -->
