# Module: gke

## Description

Configures a Nullplatform GKE provider configuration resource with cluster, gateway, resource management, security, and traffic manager settings

## Architecture

The module constructs a set of local values by merging optional inputs into a structured attributes map covering cluster identity, gateway configuration, resource management ratios, security settings, and traffic manager version. A single nullplatform_provider_config resource of type gke-configuration is created, receiving the NRN, dimensions, and the JSON-encoded attributes map. Optional fields such as private gateway name, gateway namespace, memory/CPU ratios, image pull secrets, service account, and object modifiers are conditionally included in the attributes only when non-empty. The resource acts as a declarative configuration registration within the Nullplatform control plane for a target GKE cluster.

## Features

- Creates a nullplatform_provider_config resource of type gke-configuration to register GKE cluster settings
- Configures cluster identity with name, location, and default application namespace
- Configures public and optional private Istio gateway references with namespace support
- Conditionally includes resource management settings such as memory/CPU ratios and max milicores
- Conditionally includes security settings including image pull secrets and Kubernetes service account name
- Pins traffic manager sidecar container to a fixed, explicit version tag
- Supports dynamic Kubernetes object modifiers for runtime patching of workload manifests

## Basic Usage

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/gke?ref=v7.3.1"

  cluster_name            = "your-cluster-name"
  location                = "your-location"
  nrn                     = "your-nrn"
  public_gateway_name     = "your-public-gateway-name"
  traffic_manager_version = "your-traffic-manager-version"
}
```

### Usage with Pinned Release Version

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/gke?ref=v7.3.1"

  cluster_name            = "your-cluster-name"
  location                = "your-location"
  nrn                     = "your-nrn"
  public_gateway_name     = "your-public-gateway-name"
  traffic_manager_version = "latest"
}
```

### Usage with Pinned Release Version

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/gke?ref=v7.3.1"

  cluster_name            = "your-cluster-name"
  location                = "your-location"
  nrn                     = "your-nrn"
  public_gateway_name     = "your-public-gateway-name"
  traffic_manager_version = "main"
}
```

### Usage with Pinned Release Version

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/gke?ref=v7.3.1"

  cluster_name            = "your-cluster-name"
  location                = "your-location"
  nrn                     = "your-nrn"
  public_gateway_name     = "your-public-gateway-name"
  traffic_manager_version = "master"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.gke.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.gke_config](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_gateway_namespace"></a> [gateway\_namespace](#input\_gateway\_namespace) | Kubernetes namespace where the gateway is deployed | `string` | `"istio-ingress-system"` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | List of secret names to use image pull secrets for secure access to private container images | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location where the GKE cluster is deployed (zone or region, e.g., 'us-central1-a', 'us-west1') | `string` | n/a | yes |
| <a name="input_max_cores_multiplier"></a> [max\_cores\_multiplier](#input\_max\_cores\_multiplier) | Sets the ratio between requested and limit CPU. Default value is 3, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_max_milicores"></a> [max\_milicores](#input\_max\_milicores) | Sets the maximum amount of CPU mili cores a pod can use | `string` | `""` | no |
| <a name="input_memory_cpu_ratio"></a> [memory\_cpu\_ratio](#input\_memory\_cpu\_ratio) | Amount of MiB of ram per CPU. Default value is 2048, it means 1 core for every 2 GiB of RAM | `string` | `""` | no |
| <a name="input_memory_request_to_limit_ratio"></a> [memory\_request\_to\_limit\_ratio](#input\_memory\_request\_to\_limit\_ratio) | Sets the ratio between requested and limit memory. Default value is 1, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_namespace_application_default"></a> [namespace\_application\_default](#input\_namespace\_application\_default) | Default Kubernetes namespace for applications | `string` | `"nullplatform"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z) | `string` | n/a | yes |
| <a name="input_object_modifiers"></a> [object\_modifiers](#input\_object\_modifiers) | List of modifications to dynamically modify k8s objects | <pre>list(object({<br/>    selector = string<br/>    action   = string<br/>    type     = string<br/>    value    = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private gateway | `string` | `""` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public gateway | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The name of the Kubernetes service account used for deployments | `string` | `""` | no |
| <a name="input_traffic_manager_version"></a> [traffic\_manager\_version](#input\_traffic\_manager\_version) | No default: every install pins this deliberately — see VERSIONS.md. Tag for the traffic manager sidecar container | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "gke",
  "description": "Configures a Nullplatform GKE provider configuration resource with cluster, gateway, resource management, security, and traffic manager settings",
  "architecture": "The module constructs a set of local values by merging optional inputs into a structured attributes map covering cluster identity, gateway configuration, resource management ratios, security settings, and traffic manager version. A single nullplatform_provider_config resource of type gke-configuration is created, receiving the NRN, dimensions, and the JSON-encoded attributes map. Optional fields such as private gateway name, gateway namespace, memory/CPU ratios, image pull secrets, service account, and object modifiers are conditionally included in the attributes only when non-empty. The resource acts as a declarative configuration registration within the Nullplatform control plane for a target GKE cluster.",
  "features": [
    "Creates a nullplatform_provider_config resource of type gke-configuration to register GKE cluster settings",
    "Configures cluster identity with name, location, and default application namespace",
    "Configures public and optional private Istio gateway references with namespace support",
    "Conditionally includes resource management settings such as memory/CPU ratios and max milicores",
    "Conditionally includes security settings including image pull secrets and Kubernetes service account name",
    "Pins traffic manager sidecar container to a fixed, explicit version tag",
    "Supports dynamic Kubernetes object modifiers for runtime patching of workload manifests"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z)",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "The name of the GKE cluster",
      "required": true
    },
    {
      "name": "location",
      "description": "The location where the GKE cluster is deployed (zone or region, e.g., 'us-central1-a', 'us-west1')",
      "required": true
    },
    {
      "name": "public_gateway_name",
      "description": "Name of the public gateway",
      "required": true
    },
    {
      "name": "traffic_manager_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Tag for the traffic manager sidecar container",
      "required": true
    },
    {
      "name": "dimensions",
      "description": "Dimensions for the provider configuration",
      "required": false
    },
    {
      "name": "namespace_application_default",
      "description": "Default Kubernetes namespace for applications",
      "required": false
    },
    {
      "name": "gateway_namespace",
      "description": "Kubernetes namespace where the gateway is deployed",
      "required": false
    },
    {
      "name": "private_gateway_name",
      "description": "Name of the private gateway",
      "required": false
    },
    {
      "name": "memory_cpu_ratio",
      "description": "Amount of MiB of ram per CPU. Default value is 2048, it means 1 core for every 2 GiB of RAM",
      "required": false
    },
    {
      "name": "memory_request_to_limit_ratio",
      "description": "Sets the ratio between requested and limit memory. Default value is 1, must be a number greater than or equal to 1",
      "required": false
    },
    {
      "name": "max_cores_multiplier",
      "description": "Sets the ratio between requested and limit CPU. Default value is 3, must be a number greater than or equal to 1",
      "required": false
    },
    {
      "name": "max_milicores",
      "description": "Sets the maximum amount of CPU mili cores a pod can use",
      "required": false
    },
    {
      "name": "image_pull_secrets",
      "description": "List of secret names to use image pull secrets for secure access to private container images",
      "required": false
    },
    {
      "name": "service_account_name",
      "description": "The name of the Kubernetes service account used for deployments",
      "required": false
    },
    {
      "name": "object_modifiers",
      "description": "List of modifications to dynamically modify k8s objects",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "3807d94c8072975cb9bfdbadd93ff2f3"
}
END_AI_METADATA -->
