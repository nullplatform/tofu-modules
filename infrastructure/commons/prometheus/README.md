# Module: prometheus

## Description

Deploys Prometheus using Helm chart in a specified Kubernetes namespace

## Architecture

This module creates a helm_release resource to deploy the Prometheus chart from the prometheus-community repository, and uses a templatefile to populate the prometheus_values template with the nullplatform_port variable, the resulting values are then passed to the helm_release resource, which creates the necessary Kubernetes resources, including deployments, services, and pods, in the specified namespace

## Features

- Deploys Prometheus chart with customizable nullplatform port
- Configures Kubernetes namespace for Prometheus deployment
- Creates necessary Kubernetes resources for Prometheus

## Basic Usage

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v6.3.0"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.prometheus.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nullplatform_port"></a> [nullplatform\_port](#input\_nullplatform\_port) | Port number for nullplatform service communication | `number` | `2021` | no |
| <a name="input_prometheus_namespace"></a> [prometheus\_namespace](#input\_prometheus\_namespace) | Kubernetes namespace where Prometheus will be deployed | `string` | `"prometheus"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "prometheus",
  "description": "Deploys Prometheus using Helm chart in a specified Kubernetes namespace",
  "architecture": "This module creates a helm_release resource to deploy the Prometheus chart from the prometheus-community repository, and uses a templatefile to populate the prometheus_values template with the nullplatform_port variable, the resulting values are then passed to the helm_release resource, which creates the necessary Kubernetes resources, including deployments, services, and pods, in the specified namespace",
  "features": [
    "Deploys Prometheus chart with customizable nullplatform port",
    "Configures Kubernetes namespace for Prometheus deployment",
    "Creates necessary Kubernetes resources for Prometheus"
  ],
  "inputs": [
    {
      "name": "nullplatform_port",
      "description": "Port number for nullplatform service communication",
      "required": false
    },
    {
      "name": "prometheus_namespace",
      "description": "Kubernetes namespace where Prometheus will be deployed",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "6408be4cd45c3c9a4298efeaabd20612"
}
END_AI_METADATA -->
