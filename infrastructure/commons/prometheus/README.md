# Module: prometheus

## Description

Deploys Prometheus monitoring stack into a Kubernetes cluster using the prometheus-community Helm chart with pinned versioning and opinionated release settings

## Architecture

The module renders a YAML values file via templatefile() into a local, then passes it to a single helm_release resource targeting the prometheus-community/prometheus chart. The helm_release is configured with atomic installs, cleanup on failure, and namespace auto-creation, with the chart version and namespace driven directly from input variables. No additional Kubernetes resources, IAM roles, or service accounts are created outside of what the Helm chart itself provisions.

## Features

- Deploys prometheus-community/prometheus Helm chart with a pinned, explicitly required version to prevent drift
- Creates the target Kubernetes namespace automatically via helm_release namespace management
- Enforces atomic Helm releases with automatic rollback and cleanup on failure
- Renders Prometheus configuration from a template file for consistent, repeatable values
- Maintains Helm release history capped at 10 revisions for auditability

## Basic Usage

```hcl
module "prometheus" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v9.16.0"

  prometheus_version = "your-prometheus-version"
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
| <a name="input_nullplatform_port"></a> [nullplatform\_port](#input\_nullplatform\_port) | Deprecated and ignored: Prometheus finds the logs-controller through its prometheus.io/scrape pod annotations. Remove it. | `number` | `null` | no |
| <a name="input_prometheus_namespace"></a> [prometheus\_namespace](#input\_prometheus\_namespace) | Kubernetes namespace where Prometheus will be deployed | `string` | `"prometheus"` | no |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the prometheus-community/prometheus chart. The helm\_release carried no version at all, so every apply resolved to whatever the repository served latest; the default is the version that resolved to as of 2026-08-27, which keeps behaviour unchanged while removing the drift. | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "prometheus",
  "description": "Deploys Prometheus monitoring stack into a Kubernetes cluster using the prometheus-community Helm chart with pinned versioning and opinionated release settings",
  "architecture": "The module renders a YAML values file via templatefile() into a local, then passes it to a single helm_release resource targeting the prometheus-community/prometheus chart. The helm_release is configured with atomic installs, cleanup on failure, and namespace auto-creation, with the chart version and namespace driven directly from input variables. No additional Kubernetes resources, IAM roles, or service accounts are created outside of what the Helm chart itself provisions.",
  "features": [
    "Deploys prometheus-community/prometheus Helm chart with a pinned, explicitly required version to prevent drift",
    "Creates the target Kubernetes namespace automatically via helm_release namespace management",
    "Enforces atomic Helm releases with automatic rollback and cleanup on failure",
    "Renders Prometheus configuration from a template file for consistent, repeatable values",
    "Maintains Helm release history capped at 10 revisions for auditability"
  ],
  "inputs": [
    {
      "name": "prometheus_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the prometheus-community/prometheus chart. The helm_release carried no version at all, so every apply resolved to whatever the repository served latest; the default is the version that resolved to as of 2026-08-27, which keeps behaviour unchanged while removing the drift.",
      "required": true
    },
    {
      "name": "nullplatform_port",
      "description": "Deprecated and ignored: Prometheus finds the logs-controller through its prometheus.io/scrape pod annotations. Remove it.",
      "required": false
    },
    {
      "name": "prometheus_namespace",
      "description": "Kubernetes namespace where Prometheus will be deployed",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "ae4312a533ab1f6de83b9a0e7d266126"
}
END_AI_METADATA -->
