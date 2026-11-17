# Module: istio

## Description

Deploys Istio service mesh onto a Kubernetes cluster by installing the istio-base CRDs and the istiod control plane via Helm releases with pinned versions and configurable HA replica counts

## Architecture

The module creates two sequential helm_release resources: istio-base (chart: base) and istiod (chart: istiod), where istiod depends_on istio-base to ensure CRDs exist before the control plane installs. Both helm_release resources target the same Kubernetes namespace (default: istio-system) and Helm repository, with atomic and cleanup_on_fail enabled for safe rollouts. The istiod helm_release injects pilot.replicaCount and pilot.autoscaleMin set blocks driven by var.istiod_replicas to lock in an HA floor and prevent the HPA from scaling back to 1 replica.

## Features

- Installs istio-base Helm chart with CRDs required by the Istio control plane
- Installs istiod Helm chart as the Istio control plane with an explicit dependency on istio-base
- Enforces pinned, non-moving Helm chart versions for both istio-base and istiod via validation
- Configures high-availability istiod replicas by setting both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling below the defined floor
- Enables atomic Helm releases with cleanup_on_fail and timeout controls for safe, self-healing deployments
- Creates the target Kubernetes namespace automatically via create_namespace on both releases

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.17.2"

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
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the istio-base component | `string` | n/a | yes |
| <a name="input_istiod_replicas"></a> [istiod\_replicas](#input\_istiod\_replicas) | Number of istiod replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling back to 1. | `number` | `2` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for istiod (Istio control plane) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where Istio will be installed. | `string` | `"istio-system"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The Helm repository URL (e.g., https://blob.istio.io/istio-release/charts). | `string` | `"https://blob.istio.io/istio-release/charts"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "istio",
  "description": "Deploys Istio service mesh onto a Kubernetes cluster by installing the istio-base CRDs and the istiod control plane via Helm releases with pinned versions and configurable HA replica counts",
  "architecture": "The module creates two sequential helm_release resources: istio-base (chart: base) and istiod (chart: istiod), where istiod depends_on istio-base to ensure CRDs exist before the control plane installs. Both helm_release resources target the same Kubernetes namespace (default: istio-system) and Helm repository, with atomic and cleanup_on_fail enabled for safe rollouts. The istiod helm_release injects pilot.replicaCount and pilot.autoscaleMin set blocks driven by var.istiod_replicas to lock in an HA floor and prevent the HPA from scaling back to 1 replica.",
  "features": [
    "Installs istio-base Helm chart with CRDs required by the Istio control plane",
    "Installs istiod Helm chart as the Istio control plane with an explicit dependency on istio-base",
    "Enforces pinned, non-moving Helm chart versions for both istio-base and istiod via validation",
    "Configures high-availability istiod replicas by setting both pilot.replicaCount and pilot.autoscaleMin to prevent HPA from scaling below the defined floor",
    "Enables atomic Helm releases with cleanup_on_fail and timeout controls for safe, self-healing deployments",
    "Creates the target Kubernetes namespace automatically via create_namespace on both releases"
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
      "description": "The Helm repository URL (e.g., https://blob.istio.io/istio-release/charts).",
      "required": false
    },
    {
      "name": "namespace",
      "description": "The Kubernetes namespace where Istio will be installed.",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "d9994ec7dc87f21f6b06d24622612ba3"
}
END_AI_METADATA -->
