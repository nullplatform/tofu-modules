# Module: istio

## Description

Deploys Istio service mesh onto a Kubernetes cluster by installing the istio-base CRD chart and the istiod control plane chart via Helm with pinned versions and configurable HA replica counts

## Architecture

The module creates two helm_release resources in dependency order: helm_release.istio_base installs the base CRD chart first, then helm_release.istiod depends on it and installs the control plane. Both releases target the same Kubernetes namespace (defaulting to istio-system) and pull from the same configurable Helm repository URL. The istiod release uses set blocks to inject var.istiod_replicas into both pilot.replicaCount and pilot.autoscaleMin, ensuring the HPA floor matches the desired replica count.

## Features

- Installs istio-base Helm chart with CRDs using a pinned, non-moving chart version
- Installs istiod control plane Helm chart with explicit dependency on istio-base completion
- Configures istiod HA by setting both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling below the desired floor
- Enforces fixed version strings for both charts, rejecting empty values and moving references like latest, main, or master
- Creates the target Kubernetes namespace automatically if it does not already exist
- Enables atomic installs with cleanup_on_fail and auto-rollback on timeout for both releases

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.13.1"

  istio_base_version = "your-istio-base-version"
  istiod_version     = "your-istiod-version"
}
```

### Usage with Pinned istio-base Version

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.13.1"

  istio_base_version = "latest"
  istiod_version     = "your-istiod-version"
}
```

### Usage with Pinned istio-base Version (main)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.13.1"

  istio_base_version = "main"
  istiod_version     = "your-istiod-version"
}
```

### Usage with Pinned istio-base Version (master)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.13.1"

  istio_base_version = "master"
  istiod_version     = "your-istiod-version"
}
```

### Usage with Pinned istiod Version

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.13.1"

  istio_base_version = "your-istio-base-version"
  istiod_version     = "latest"
}
```

### Usage with Pinned istiod Version (main)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.13.1"

  istio_base_version = "your-istio-base-version"
  istiod_version     = "main"
}
```

### Usage with Pinned istiod Version (master)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.13.1"

  istio_base_version = "your-istio-base-version"
  istiod_version     = "master"
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
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the istio-base component | `string` | n/a | yes |
| <a name="input_istiod_replicas"></a> [istiod\_replicas](#input\_istiod\_replicas) | Number of istiod replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling back to 1. | `number` | `2` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for istiod (Istio control plane) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where Istio will be installed. | `string` | `"istio-system"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts). | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "istio",
  "description": "Deploys Istio service mesh onto a Kubernetes cluster by installing the istio-base CRD chart and the istiod control plane chart via Helm with pinned versions and configurable HA replica counts",
  "architecture": "The module creates two helm_release resources in dependency order: helm_release.istio_base installs the base CRD chart first, then helm_release.istiod depends on it and installs the control plane. Both releases target the same Kubernetes namespace (defaulting to istio-system) and pull from the same configurable Helm repository URL. The istiod release uses set blocks to inject var.istiod_replicas into both pilot.replicaCount and pilot.autoscaleMin, ensuring the HPA floor matches the desired replica count.",
  "features": [
    "Installs istio-base Helm chart with CRDs using a pinned, non-moving chart version",
    "Installs istiod control plane Helm chart with explicit dependency on istio-base completion",
    "Configures istiod HA by setting both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling below the desired floor",
    "Enforces fixed version strings for both charts, rejecting empty values and moving references like latest, main, or master",
    "Creates the target Kubernetes namespace automatically if it does not already exist",
    "Enables atomic installs with cleanup_on_fail and auto-rollback on timeout for both releases"
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
      "name": "repository",
      "description": "The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts).",
      "required": false
    },
    {
      "name": "namespace",
      "description": "The Kubernetes namespace where Istio will be installed.",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "303874396410b43ece75fa7d7b391834"
}
END_AI_METADATA -->
