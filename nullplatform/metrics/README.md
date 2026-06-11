# Module: metrics

## Description

Configures a Prometheus provider in Nullplatform with automatic server URL resolution from Kubernetes service discovery or custom endpoint

## Architecture

The module creates a nullplatform_provider_config resource of type prometheus that stores connection configuration in a JSON-encoded attributes block. It uses a local value to determine the Prometheus server URL, either accepting a custom var.prometheus_url or auto-generating a Kubernetes cluster-internal service URL using the format http://prometheus-server.<namespace>.svc.cluster.local:80. The resource accepts dimensions metadata and includes lifecycle rules to ignore changes to attributes after initial creation.

## Features

- Creates Nullplatform provider configuration for Prometheus integration
- Auto-generates Kubernetes service discovery URL for Prometheus server when custom URL not provided
- Supports custom Prometheus endpoint URL for external or non-standard deployments
- Configures namespace-aware internal cluster service URLs using Kubernetes DNS naming
- Applies lifecycle ignore_changes to prevent attribute drift on subsequent applies
- Associates provider configuration with dimensions for multi-tenant or environment-specific setups

## Basic Usage

```hcl
module "metrics" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/metrics?ref=v4.3.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.86 |

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
  "description": "Configures a Prometheus provider in Nullplatform with automatic server URL resolution from Kubernetes service discovery or custom endpoint",
  "architecture": "The module creates a nullplatform_provider_config resource of type prometheus that stores connection configuration in a JSON-encoded attributes block. It uses a local value to determine the Prometheus server URL, either accepting a custom var.prometheus_url or auto-generating a Kubernetes cluster-internal service URL using the format http://prometheus-server.<namespace>.svc.cluster.local:80. The resource accepts dimensions metadata and includes lifecycle rules to ignore changes to attributes after initial creation.",
  "features": [
    "Creates Nullplatform provider configuration for Prometheus integration",
    "Auto-generates Kubernetes service discovery URL for Prometheus server when custom URL not provided",
    "Supports custom Prometheus endpoint URL for external or non-standard deployments",
    "Configures namespace-aware internal cluster service URLs using Kubernetes DNS naming",
    "Applies lifecycle ignore_changes to prevent attribute drift on subsequent applies",
    "Associates provider configuration with dimensions for multi-tenant or environment-specific setups"
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
  "hash": "53cef1f8ff4770b8ec9cfa0b736eef61"
}
END_AI_METADATA -->
