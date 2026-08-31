# Module: istio

## Description

Deploys the Istio service mesh control plane (istio-base and istiod) on Kubernetes using sequenced Helm releases. Ingress traffic is expected to be handled by Kubernetes Gateway API resources (provisioned by istiod on demand), not by a standalone ingress gateway.

## Architecture

Two helm_release resources are created in a strict dependency chain: istio-base is deployed first (CRDs, including Gateway API support), and istiod depends on istio-base and configures pilot.replicaCount and pilot.autoscaleMin via dynamic set blocks using var.istiod_replicas. Gateway data-plane pods are not installed by this module: istiod auto-provisions them from Gateway API resources (gatewayClassName: istio) declared elsewhere (e.g. the nullplatform-base Helm chart).

## Features

- Deploys istio-base and istiod Helm charts in dependency order with atomic and cleanup-on-fail guarantees
- Configures istiod HA by setting both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling below the desired replica floor
- Allows namespace, Helm repository URL, and individual chart versions to be overridden independently for each Istio component

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v6.21.0"
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
  "description": "Deploys the Istio service mesh control plane (istio-base and istiod) on Kubernetes using sequenced Helm releases; ingress is handled by Gateway API resources provisioned by istiod, not by a standalone ingress gateway",
  "architecture": "Two helm_release resources are created in a strict dependency chain: istio-base is deployed first (CRDs, including Gateway API support), and istiod depends on istio-base and configures pilot.replicaCount and pilot.autoscaleMin via dynamic set blocks using var.istiod_replicas. Gateway data-plane pods are auto-provisioned by istiod from Gateway API resources declared outside this module.",
  "features": [
    "Deploys istio-base and istiod Helm charts in dependency order with atomic and cleanup-on-fail guarantees",
    "Configures istiod HA by setting both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling below the desired replica floor",
    "Allows namespace, Helm repository URL, and individual chart versions to be overridden independently for each Istio component"
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
  "hash": "fb600ec91beb6dc11983964b7648cb75"
}
END_AI_METADATA -->
