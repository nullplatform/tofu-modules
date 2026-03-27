# Module: metrics

## Description

Creates a nullplatform provider configuration for Prometheus metrics scraping integration

## Architecture

The module creates a single nullplatform_provider_config resource of type 'prometheus' that stores the Prometheus server connection details. It uses a local variable to determine the server URL, either from the prometheus_url input variable or by constructing a default Kubernetes service URL using the prometheus_namespace variable. The configuration attributes are JSON-encoded and include the server URL, while the lifecycle block ignores changes to attributes to prevent configuration drift.

## Features

- Creates nullplatform provider configuration for Prometheus integration
- Configures Prometheus server URL either from custom input or default Kubernetes service discovery
- Constructs default URL using Kubernetes DNS pattern for in-cluster Prometheus access
- Supports custom dimensions for provider configuration scoping
- Implements lifecycle management to ignore external attribute changes
- Stores configuration as JSON-encoded attributes within the provider config resource

## Basic Usage

```hcl
module "metrics" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/metrics?ref=v1.48.3"

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
| <a name="input_prometheus_url"></a> [prometheus\_url](#input\_prometheus\_url) | URL of the Prometheus instance used for metrics scraping | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "metrics",
  "description": "Creates a nullplatform provider configuration for Prometheus metrics scraping integration",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'prometheus' that stores the Prometheus server connection details. It uses a local variable to determine the server URL, either from the prometheus_url input variable or by constructing a default Kubernetes service URL using the prometheus_namespace variable. The configuration attributes are JSON-encoded and include the server URL, while the lifecycle block ignores changes to attributes to prevent configuration drift.",
  "features": [
    "Creates nullplatform provider configuration for Prometheus integration",
    "Configures Prometheus server URL either from custom input or default Kubernetes service discovery",
    "Constructs default URL using Kubernetes DNS pattern for in-cluster Prometheus access",
    "Supports custom dimensions for provider configuration scoping",
    "Implements lifecycle management to ignore external attribute changes",
    "Stores configuration as JSON-encoded attributes within the provider config resource"
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
      "description": "URL of the Prometheus instance used for metrics scraping",
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
  "hash": "781694146ee8f048b9a4318fe6631c82"
}
END_AI_METADATA -->
