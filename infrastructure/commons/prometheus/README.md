# Module: prometheus

## Description

Deploys Prometheus monitoring system to a Kubernetes cluster using Helm with customized configuration for nullplatform integration

## Features

- Deploys Prometheus using the official Helm chart from prometheus-community repository
- Creates and manages a dedicated Kubernetes namespace for Prometheus deployment
- Configures Prometheus with templated values for nullplatform service integration
- Enables atomic deployment with automatic cleanup on failure
- Manages Helm release lifecycle with forced updates and pod recreation
- Maintains deployment history with a maximum of 10 revisions

## Basic Usage

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v1.34.0"
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
