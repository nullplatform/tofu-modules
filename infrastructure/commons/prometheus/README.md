# Module: prometheus

## Description

Deploys Prometheus monitoring stack into a Kubernetes cluster using the prometheus-community Helm chart with opinionated release settings

## Architecture

A single helm_release resource named 'prometheus' installs the prometheus-community/prometheus chart into the namespace defined by var.prometheus_namespace, with the chart version pinned via var.prometheus_version. A templatefile-rendered locals block produces the Helm values YAML by interpolating var.nullplatform_port into a template file, and that rendered string is passed as the sole values override to the helm_release. Release lifecycle flags such as atomic, cleanup_on_fail, and recreate_pods are hardcoded to enforce deterministic, self-healing deployments on every apply.

## Features

- Deploys prometheus-community/prometheus Helm chart with a pinned, explicit chart version to prevent drift
- Renders Helm values from a template file with configurable nullplatform service port injection
- Creates the target Kubernetes namespace automatically via create_namespace flag
- Enforces atomic, self-healing releases with cleanup_on_fail and recreate_pods enabled
- Caps Helm release history to 10 revisions to limit etcd storage growth
- Configures a 600-second timeout with wait_for_jobs to ensure all Prometheus workloads reach ready state before completing

## Basic Usage

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v6.23.0"

  prometheus_version = "your-prometheus-version"
}
```

### Usage with Pinned Release Version

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v6.23.0"

  prometheus_version = "latest"
}
```

### Usage with Pinned Release Version

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v6.23.0"

  prometheus_version = "main"
}
```

### Usage with Pinned Release Version

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v6.23.0"

  prometheus_version = "master"
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
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nullplatform_port"></a> [nullplatform\_port](#input\_nullplatform\_port) | Port number for nullplatform service communication | `number` | `2021` | no |
| <a name="input_prometheus_namespace"></a> [prometheus\_namespace](#input\_prometheus\_namespace) | Kubernetes namespace where Prometheus will be deployed | `string` | `"prometheus"` | no |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the prometheus-community/prometheus chart. The helm\_release carried no version at all, so every apply resolved to whatever the repository served latest; the default is the version that resolved to as of 2026-08-27, which keeps behaviour unchanged while removing the drift. | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "prometheus",
  "description": "Deploys Prometheus monitoring stack into a Kubernetes cluster using the prometheus-community Helm chart with opinionated release settings",
  "architecture": "A single helm_release resource named 'prometheus' installs the prometheus-community/prometheus chart into the namespace defined by var.prometheus_namespace, with the chart version pinned via var.prometheus_version. A templatefile-rendered locals block produces the Helm values YAML by interpolating var.nullplatform_port into a template file, and that rendered string is passed as the sole values override to the helm_release. Release lifecycle flags such as atomic, cleanup_on_fail, and recreate_pods are hardcoded to enforce deterministic, self-healing deployments on every apply.",
  "features": [
    "Deploys prometheus-community/prometheus Helm chart with a pinned, explicit chart version to prevent drift",
    "Renders Helm values from a template file with configurable nullplatform service port injection",
    "Creates the target Kubernetes namespace automatically via create_namespace flag",
    "Enforces atomic, self-healing releases with cleanup_on_fail and recreate_pods enabled",
    "Caps Helm release history to 10 revisions to limit etcd storage growth",
    "Configures a 600-second timeout with wait_for_jobs to ensure all Prometheus workloads reach ready state before completing"
  ],
  "inputs": [
    {
      "name": "prometheus_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the prometheus-community/prometheus chart. The helm_release carried no version at all, so every apply resolved to whatever the repository served latest; the default is the version that resolved to as of 2026-08-27, which keeps behaviour unchanged while removing the drift.",
      "required": true
    },
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
  "hash": "79442cc6d407bd4ef2dcfbbf74c63933"
}
END_AI_METADATA -->
