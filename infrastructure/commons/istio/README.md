# Module: istio

## Description

Deploys Istio service mesh onto a Kubernetes cluster using Helm, installing both the istio-base CRDs and the istiod control plane with configurable high-availability replica settings

## Architecture

The module creates two helm_release resources in sequence: first istio-base (which installs Istio CRDs and cluster-wide resources), then istiod (which depends on istio-base and installs the Istio control plane). The istiod helm_release uses set blocks to configure both pilot.replicaCount and pilot.autoscaleMin from the istiod_replicas variable, ensuring the HPA cannot scale below the specified floor. Both releases target the same Kubernetes namespace, which is created automatically if it does not exist.

## Features

- Installs istio-base Helm chart providing Istio CRDs and cluster-scoped RBAC resources
- Deploys istiod Helm chart as the Istio control plane with explicit dependency on istio-base
- Configures high-availability istiod replicas by setting both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling back to 1
- Enforces atomic Helm deployments with automatic cleanup on failure for both releases
- Supports configurable Helm chart versions for independent upgrades of istio-base and istiod
- Creates the target Kubernetes namespace automatically if it does not already exist

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v8.0.0"
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
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | Helm chart version for the istio-base component | `string` | `"1.27.1"` | no |
| <a name="input_istiod_replicas"></a> [istiod\_replicas](#input\_istiod\_replicas) | Number of istiod replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling back to 1. | `number` | `2` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | Helm chart version for istiod (Istio control plane) | `string` | `"1.27.1"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where Istio will be installed. | `string` | `"istio-system"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts). | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "istio",
  "description": "Deploys Istio service mesh onto a Kubernetes cluster using Helm, installing both the istio-base CRDs and the istiod control plane with configurable high-availability replica settings",
  "architecture": "The module creates two helm_release resources in sequence: first istio-base (which installs Istio CRDs and cluster-wide resources), then istiod (which depends on istio-base and installs the Istio control plane). The istiod helm_release uses set blocks to configure both pilot.replicaCount and pilot.autoscaleMin from the istiod_replicas variable, ensuring the HPA cannot scale below the specified floor. Both releases target the same Kubernetes namespace, which is created automatically if it does not exist.",
  "features": [
    "Installs istio-base Helm chart providing Istio CRDs and cluster-scoped RBAC resources",
    "Deploys istiod Helm chart as the Istio control plane with explicit dependency on istio-base",
    "Configures high-availability istiod replicas by setting both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling back to 1",
    "Enforces atomic Helm deployments with automatic cleanup on failure for both releases",
    "Supports configurable Helm chart versions for independent upgrades of istio-base and istiod",
    "Creates the target Kubernetes namespace automatically if it does not already exist"
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
  "hash": "ea84fce6f9b7569f610a7538080da00f"
}
END_AI_METADATA -->
