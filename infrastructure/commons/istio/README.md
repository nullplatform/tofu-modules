# Module: istio

## Description

Installs and configures Istio service mesh (istio-base and istiod) on Kubernetes using Helm with pinned versions and HA-aware settings

## Architecture

The module creates two helm_release resources: istio-base (CRDs and cluster-wide resources) and istiod (the Istio control plane), where istiod depends_on istio-base to enforce install order. Input variables flow into helm_release.istiod via set blocks for pilot.replicaCount, pilot.autoscaleMin, and optionally global.hub, and via set_list for global.imagePullSecrets. When gateway_access_log_enabled is true, a structured JSON access log meshConfig extension provider is injected into istiod via a yamlencode values block.

## Features

- Installs istio-base Helm chart with CRDs and cluster-scoped Istio resources into a configurable namespace
- Deploys istiod Helm chart with atomic, cleanup-on-fail, and wait semantics for reliable upgrades
- Enforces HA for istiod by setting both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling below the configured floor
- Configures a structured JSON gateway access log extension provider (np-gateway-access-log) in meshConfig when enabled
- Supports private image registries by setting global.hub and global.imagePullSecrets on istiod and injected proxies
- Validates that version pins are non-empty fixed strings and disallows moving references like latest, main, or master

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.21.0"

  istio_base_version = "your-istio-base-version"
  istiod_version     = "your-istiod-version"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.istio.id
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
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.1.1 |

## Resources

| Name | Type |
|------|------|
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gateway_access_log_enabled"></a> [gateway\_access\_log\_enabled](#input\_gateway\_access\_log\_enabled) | Add the np-gateway-access-log extension provider (JSON access log to stdout) to istiod's meshConfig. Required by the logs-controller for scopes without the nginx sidecar (nullplatform/base logging\_istio\_access\_logs\_enabled). | `bool` | `false` | no |
| <a name="input_image_hub"></a> [image\_hub](#input\_image\_hub) | Registry and path Istio images are pulled from, without a tag (e.g., docker.io/istio, or a private mirror such as myregistry.example.com/istio). Sets global.hub, which applies to istiod and to the proxy injected into sidecars and gateways. Null keeps the chart default: docker.io/istio up to 1.29, registry.istio.io/release in 1.30.x, which upstream is decommissioning. | `string` | `null` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | Names of image pull secrets for istiod and for the proxy injected into sidecars and gateways, for a hub that needs credentials (see image\_hub). Sets global.imagePullSecrets. The module does not create them: each must exist in istio-system and in every namespace with injected pods. Empty keeps the chart default. | `list(string)` | `[]` | no |
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the istio-base component | `string` | n/a | yes |
| <a name="input_istiod_replicas"></a> [istiod\_replicas](#input\_istiod\_replicas) | Number of istiod replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling back to 1. | `number` | `2` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for istiod (Istio control plane) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where Istio will be installed. | `string` | `"istio-system"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The Helm repository URL (e.g., https://blob.istio.io/istio-release/charts). | `string` | `"https://blob.istio.io/istio-release/charts"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "istio",
  "description": "Installs and configures Istio service mesh (istio-base and istiod) on Kubernetes using Helm with pinned versions and HA-aware settings",
  "architecture": "The module creates two helm_release resources: istio-base (CRDs and cluster-wide resources) and istiod (the Istio control plane), where istiod depends_on istio-base to enforce install order. Input variables flow into helm_release.istiod via set blocks for pilot.replicaCount, pilot.autoscaleMin, and optionally global.hub, and via set_list for global.imagePullSecrets. When gateway_access_log_enabled is true, a structured JSON access log meshConfig extension provider is injected into istiod via a yamlencode values block.",
  "features": [
    "Installs istio-base Helm chart with CRDs and cluster-scoped Istio resources into a configurable namespace",
    "Deploys istiod Helm chart with atomic, cleanup-on-fail, and wait semantics for reliable upgrades",
    "Enforces HA for istiod by setting both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling below the configured floor",
    "Configures a structured JSON gateway access log extension provider (np-gateway-access-log) in meshConfig when enabled",
    "Supports private image registries by setting global.hub and global.imagePullSecrets on istiod and injected proxies",
    "Validates that version pins are non-empty fixed strings and disallows moving references like latest, main, or master"
  ],
  "inputs": [
    {
      "name": "istio_base_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the istio-base component",
      "required": true
    },
    {
      "name": "istiod_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for istiod (Istio control plane)",
      "required": true
    },
    {
      "name": "istiod_replicas",
      "description": "Number of istiod replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling back to 1.",
      "required": false
    },
    {
      "name": "image_hub",
      "description": "Registry and path Istio images are pulled from, without a tag (e.g., docker.io/istio, or a private mirror such as myregistry.example.com/istio). Sets global.hub, which applies to istiod and to the proxy injected into sidecars and gateways. Null keeps the chart default: docker.io/istio up to 1.29, registry.istio.io/release in 1.30.x, which upstream is decommissioning.",
      "required": false
    },
    {
      "name": "image_pull_secrets",
      "description": "Names of image pull secrets for istiod and for the proxy injected into sidecars and gateways, for a hub that needs credentials (see image_hub). Sets global.imagePullSecrets. The module does not create them: each must exist in istio-system and in every namespace with injected pods. Empty keeps the chart default.",
      "required": false
    },
    {
      "name": "repository",
      "description": "The Helm repository URL (e.g., https://blob.istio.io/istio-release/charts).",
      "required": false
    },
    {
      "name": "namespace",
      "description": "The Kubernetes namespace where Istio will be installed.",
      "required": false
    },
    {
      "name": "gateway_access_log_enabled",
      "description": "Add the np-gateway-access-log extension provider (JSON access log to stdout) to istiod's meshConfig. Required by the logs-controller for scopes without the nginx sidecar (nullplatform/base logging_istio_access_logs_enabled).",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "4e9e9d1d21fc6a300d6747d9a07c1bb7"
}
END_AI_METADATA -->
