# Module: prometheus

## Description

Deploys Prometheus monitoring system to a Kubernetes cluster using Helm with configurable namespace and nullplatform integration

## Features

- Deploys Prometheus using the official prometheus-community Helm chart
- Configures automatic namespace creation for Prometheus deployment
- Integrates with nullplatform service through configurable port settings
- Implements comprehensive Helm release management with atomic updates and rollback capabilities
- Applies templated configuration values for customized Prometheus setup
- Enforces strict deployment practices with force updates and pod recreation
- Maintains deployment history with configurable retention limit

## Basic Usage

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v1.42.0"
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
