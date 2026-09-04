# Module: prometheus

## Description

Deploys Prometheus monitoring stack into a Kubernetes cluster using the prometheus-community Helm chart with a pinned version and templated values

## Architecture

The module renders a YAML values file via templatefile() in locals.tf, injecting the nullplatform_port variable into a prometheus_values.tmpl.yaml template. A single helm_release resource named 'prometheus' is created targeting the prometheus-community/prometheus chart at the specified pinned version, deploying into the configured Kubernetes namespace. The rendered template values are passed directly to the helm_release values argument, and Helm lifecycle options such as atomic, cleanup_on_fail, and wait_for_jobs are hardcoded to enforce reliable deployment behavior.

## Features

- Deploys prometheus-community/prometheus Helm chart with a mandatory pinned version to prevent version drift
- Creates a dedicated Kubernetes namespace automatically via helm_release create_namespace
- Renders a templated Prometheus values YAML file with configurable nullplatform service port
- Enforces atomic Helm releases with automatic cleanup on failure and pod recreation
- Configures Helm release with dependency_update and max_history tracking for safe upgrades

## Basic Usage

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v7.3.1"

  prometheus_version = "your-prometheus-version"
}
```

### Usage with Latest Version (Blocked)

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v7.3.1"

  prometheus_version = "latest"
}
```

### Usage with Main Branch Reference (Blocked)

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v7.3.1"

  prometheus_version = "main"
}
```

### Usage with Master Branch Reference (Blocked)

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v7.3.1"

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
  "description": "Deploys Prometheus monitoring stack into a Kubernetes cluster using the prometheus-community Helm chart with a pinned version and templated values",
  "architecture": "The module renders a YAML values file via templatefile() in locals.tf, injecting the nullplatform_port variable into a prometheus_values.tmpl.yaml template. A single helm_release resource named 'prometheus' is created targeting the prometheus-community/prometheus chart at the specified pinned version, deploying into the configured Kubernetes namespace. The rendered template values are passed directly to the helm_release values argument, and Helm lifecycle options such as atomic, cleanup_on_fail, and wait_for_jobs are hardcoded to enforce reliable deployment behavior.",
  "features": [
    "Deploys prometheus-community/prometheus Helm chart with a mandatory pinned version to prevent version drift",
    "Creates a dedicated Kubernetes namespace automatically via helm_release create_namespace",
    "Renders a templated Prometheus values YAML file with configurable nullplatform service port",
    "Enforces atomic Helm releases with automatic cleanup on failure and pod recreation",
    "Configures Helm release with dependency_update and max_history tracking for safe upgrades"
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
