# Module: metrics

## Description

Configures a Prometheus provider integration in nullplatform by registering the Prometheus server URL as a provider configuration resource

## Architecture

The module creates a single nullplatform_provider_config resource of type 'prometheus' that registers the Prometheus server endpoint with the nullplatform platform. A local value resolves the effective Prometheus URL, either using the explicitly provided var.prometheus_url or constructing a Kubernetes in-cluster DNS address from var.prometheus_namespace. The resulting URL is encoded as a JSON attribute and stored in the provider config alongside optional dimension metadata supplied via var.dimensions. The nrn input uniquely identifies the target nullplatform resource receiving this configuration.

## Features

- Creates a nullplatform_provider_config resource that registers Prometheus as a metrics provider
- Constructs an in-cluster Kubernetes DNS URL automatically when no explicit Prometheus URL is provided
- Validates that the prometheus_url value conforms to http:// or https:// scheme when specified
- Supports custom Kubernetes namespace targeting for automatic Prometheus service discovery
- Attaches optional dimension metadata to the provider configuration for multi-tenant or scoped deployments
- Ignores downstream attribute drift via lifecycle ignore_changes to prevent unintended updates

## Basic Usage

```hcl
module "metrics" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/metrics?ref=v7.3.1"

  nrn = "your-nrn"
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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.prometheus](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | name of the dimensions | `map` | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | nullplatform Resource Name — unique identifier for resources | `string` | n/a | yes |
| <a name="input_prometheus_namespace"></a> [prometheus\_namespace](#input\_prometheus\_namespace) | Kubernetes namespace where Prometheus will be deployed | `string` | `"prometheus"` | no |
| <a name="input_prometheus_url"></a> [prometheus\_url](#input\_prometheus\_url) | URL of the Prometheus instance used for metrics scraping | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "metrics",
  "description": "Configures a Prometheus provider integration in nullplatform by registering the Prometheus server URL as a provider configuration resource",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'prometheus' that registers the Prometheus server endpoint with the nullplatform platform. A local value resolves the effective Prometheus URL, either using the explicitly provided var.prometheus_url or constructing a Kubernetes in-cluster DNS address from var.prometheus_namespace. The resulting URL is encoded as a JSON attribute and stored in the provider config alongside optional dimension metadata supplied via var.dimensions. The nrn input uniquely identifies the target nullplatform resource receiving this configuration.",
  "features": [
    "Creates a nullplatform_provider_config resource that registers Prometheus as a metrics provider",
    "Constructs an in-cluster Kubernetes DNS URL automatically when no explicit Prometheus URL is provided",
    "Validates that the prometheus_url value conforms to http:// or https:// scheme when specified",
    "Supports custom Kubernetes namespace targeting for automatic Prometheus service discovery",
    "Attaches optional dimension metadata to the provider configuration for multi-tenant or scoped deployments",
    "Ignores downstream attribute drift via lifecycle ignore_changes to prevent unintended updates"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "nullplatform Resource Name — unique identifier for resources",
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
  "hash": "1a62b01ad80634cbebcf25d7f50be2bf"
}
END_AI_METADATA -->
