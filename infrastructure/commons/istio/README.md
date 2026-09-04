# Module: istio

## Description

Deploys Istio service mesh onto a Kubernetes cluster using the official Helm charts for both the istio-base CRDs and the istiod control plane

## Architecture

The module creates two helm_release resources: istio-base (which installs the Istio CRDs and cluster-wide base configuration) and istiod (the Istio control plane, which depends on istio-base completing successfully). Both helm_release resources target the same Kubernetes namespace and Helm repository, with istiod receiving additional set blocks to configure pilot.replicaCount and pilot.autoscaleMin from the istiod_replicas variable. This ensures the HPA floor matches the desired replica count, preventing the PDB from blocking node drains.

## Features

- Installs istio-base Helm chart with cluster-scoped CRDs and base configuration
- Deploys istiod Helm chart as the Istio control plane with enforced dependency ordering
- Configures both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling below the desired replica floor
- Enables high-availability istiod deployments by defaulting to 2 replicas to avoid PDB-blocked node drains
- Applies atomic, cleanup-on-fail, and wait semantics to both Helm releases for safe rollout behavior
- Supports configurable Helm chart versions for independent upgrades of istio-base and istiod

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v7.3.1"
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
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | Helm chart version for the istio-base component | `string` | `"1.30.4"` | no |
| <a name="input_istiod_replicas"></a> [istiod\_replicas](#input\_istiod\_replicas) | Number of istiod replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling back to 1. | `number` | `2` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | Helm chart version for istiod (Istio control plane) | `string` | `"1.30.4"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where Istio will be installed. | `string` | `"istio-system"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts). | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "istio",
  "description": "Deploys Istio service mesh onto a Kubernetes cluster using the official Helm charts for both the istio-base CRDs and the istiod control plane",
  "architecture": "The module creates two helm_release resources: istio-base (which installs the Istio CRDs and cluster-wide base configuration) and istiod (the Istio control plane, which depends on istio-base completing successfully). Both helm_release resources target the same Kubernetes namespace and Helm repository, with istiod receiving additional set blocks to configure pilot.replicaCount and pilot.autoscaleMin from the istiod_replicas variable. This ensures the HPA floor matches the desired replica count, preventing the PDB from blocking node drains.",
  "features": [
    "Installs istio-base Helm chart with cluster-scoped CRDs and base configuration",
    "Deploys istiod Helm chart as the Istio control plane with enforced dependency ordering",
    "Configures both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling below the desired replica floor",
    "Enables high-availability istiod deployments by defaulting to 2 replicas to avoid PDB-blocked node drains",
    "Applies atomic, cleanup-on-fail, and wait semantics to both Helm releases for safe rollout behavior",
    "Supports configurable Helm chart versions for independent upgrades of istio-base and istiod"
  ],
  "inputs": [
    {
      "name": "istiod_replicas",
      "description": "Number of istiod replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling back to 1.",
      "required": false
    },
    {
      "name": "istio_base_version",
      "description": "Helm chart version for the istio-base component",
      "required": false
    },
    {
      "name": "istiod_version",
      "description": "Helm chart version for istiod (Istio control plane)",
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
  "hash": "0bcbe546864dd02baf37e63271bcb6fe"
}
END_AI_METADATA -->
