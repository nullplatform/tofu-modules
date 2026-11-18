# Module: istio

## Description

Installs Istio service mesh on Kubernetes by deploying the istio-base CRDs and the istiod control plane via pinned Helm chart versions

## Architecture

The module creates two helm_release resources: istio-base (chart: base) and istiod (chart: istiod), with istiod depending on istio-base via depends_on. Both releases target the same Kubernetes namespace and use the shared Helm repository URL. Input variables flow into helm_release arguments including version pinning, replica counts via set blocks (pilot.replicaCount and pilot.autoscaleMin), optional global.hub via a conditional set entry, and optional global.imagePullSecrets via set_list when image_pull_secrets is non-empty.

## Features

- Deploys istio-base Helm release with CRDs required by the Istio control plane
- Deploys istiod Helm release with configurable replica count applied to both replicaCount and autoscaleMin to prevent HPA from scaling below the floor
- Enforces pinned Helm chart versions for both istio-base and istiod, rejecting floating references like latest, main, or master
- Configures custom image registry via global.hub for air-gapped or private mirror deployments
- Mounts image pull secrets via global.imagePullSecrets for authenticated private registries
- Enables atomic, cleanup-on-fail Helm deployments with a 600-second timeout to ensure rollback on failure

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.18.0"

  istio_base_version = "your-istio-base-version"
  istiod_version     = "your-istiod-version"
}
```

### Usage with Pinned istio-base version (non-latest)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.18.0"

  istio_base_version = "latest"
  istiod_version     = "your-istiod-version"
}
```

### Usage with Pinned istio-base version (non-main)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.18.0"

  istio_base_version = "main"
  istiod_version     = "your-istiod-version"
}
```

### Usage with Pinned istio-base version (non-master)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.18.0"

  istio_base_version = "master"
  istiod_version     = "your-istiod-version"
}
```

### Usage with Pinned istiod version (non-latest)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.18.0"

  istio_base_version = "your-istio-base-version"
  istiod_version     = "latest"
}
```

### Usage with Pinned istiod version (non-main)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.18.0"

  istio_base_version = "your-istio-base-version"
  istiod_version     = "main"
}
```

### Usage with Pinned istiod version (non-master)

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v9.18.0"

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
  "description": "Installs Istio service mesh on Kubernetes by deploying the istio-base CRDs and the istiod control plane via pinned Helm chart versions",
  "architecture": "The module creates two helm_release resources: istio-base (chart: base) and istiod (chart: istiod), with istiod depending on istio-base via depends_on. Both releases target the same Kubernetes namespace and use the shared Helm repository URL. Input variables flow into helm_release arguments including version pinning, replica counts via set blocks (pilot.replicaCount and pilot.autoscaleMin), optional global.hub via a conditional set entry, and optional global.imagePullSecrets via set_list when image_pull_secrets is non-empty.",
  "features": [
    "Deploys istio-base Helm release with CRDs required by the Istio control plane",
    "Deploys istiod Helm release with configurable replica count applied to both replicaCount and autoscaleMin to prevent HPA from scaling below the floor",
    "Enforces pinned Helm chart versions for both istio-base and istiod, rejecting floating references like latest, main, or master",
    "Configures custom image registry via global.hub for air-gapped or private mirror deployments",
    "Mounts image pull secrets via global.imagePullSecrets for authenticated private registries",
    "Enables atomic, cleanup-on-fail Helm deployments with a 600-second timeout to ensure rollback on failure"
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
    }
  ],
  "outputs": [],
  "hash": "011ccca54e178536fcc51c7ce5bd4675"
}
END_AI_METADATA -->
