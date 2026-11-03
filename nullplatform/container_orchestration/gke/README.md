# Module: gke

## Description

Configures a GKE provider configuration in Nullplatform by creating a nullplatform_provider_config resource with cluster, gateway, traffic manager, and naming settings

## Architecture

The module constructs a single nullplatform_provider_config resource of type 'gke-configuration' by merging multiple local maps (gateway, resource_management, security, naming) into a JSON-encoded attributes payload. Input variables for cluster identity (cluster_name, location), gateway routing (public_gateway_name, private_gateway_name, additional_public_gateways, additional_private_gateways), traffic manager versioning, and Kubernetes naming strategy are composed into nested locals before being serialized via jsonencode. The nullplatform_provider_config resource binds all configuration to the target NRN scope using the nrn and dimensions inputs, enabling Nullplatform to manage GKE workload deployments against the described cluster.

## Features

- Creates a nullplatform_provider_config resource encoding GKE cluster identity and location for Nullplatform workload management
- Configures public and private Kubernetes Gateway API gateway references with optional namespace and additional gateway attachments
- Pins traffic manager sidecar container to an explicit version tag, rejecting moving references like 'latest', 'main', or 'master'
- Supports flexible Kubernetes object naming strategies including id-based, slug-qualified, and fully custom pattern modes
- Configures resource management tuning parameters including memory-to-CPU ratio, request-to-limit ratios, and max milicores limits
- Manages image pull secrets and Kubernetes service account bindings for secure private container image access
- Applies dynamic Kubernetes object modifiers for post-render patching of cluster resources

## Basic Usage

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/gke?ref=v9.11.0"

  cluster_name            = "your-cluster-name"
  location                = "your-location"
  nrn                     = "your-nrn"
  public_gateway_name     = "your-public-gateway-name"
  traffic_manager_version = "your-traffic-manager-version"
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
| <a name="input_additional_private_gateways"></a> [additional\_private\_gateways](#input\_additional\_private\_gateways) | Extra gateways the HTTPRoute of private scopes is also attached to, besides the private gateway. namespace defaults to the gateway namespace. Every gateway must exist in the cluster | <pre>list(object({<br/>    name      = string<br/>    namespace = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_public_gateways"></a> [additional\_public\_gateways](#input\_additional\_public\_gateways) | Extra gateways the HTTPRoute of public scopes is also attached to, besides the public gateway. namespace defaults to the gateway namespace. Every gateway must exist in the cluster | <pre>list(object({<br/>    name      = string<br/>    namespace = optional(string)<br/>  }))</pre> | `[]` | no |
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
| <a name="input_naming_deployment_pattern"></a> [naming\_deployment\_pattern](#input\_naming\_deployment\_pattern) | Name pattern for the objects a deployment creates (Deployment, Service, HPA, Secret, PodDisruptionBudget), e.g. {.application.slug}-{.scope.slug}-{.deployment.id}. Read only when naming\_strategy is 'custom' | `string` | `""` | no |
| <a name="input_naming_scope_pattern"></a> [naming\_scope\_pattern](#input\_naming\_scope\_pattern) | Name pattern for the objects that outlive a deployment (Ingress, HTTPRoute, serving certificate), e.g. {.application.slug}-{.scope.slug}-{.scope.id}. Read only when naming\_strategy is 'custom'. Only applies to scopes created after the change | `string` | `""` | no |
| <a name="input_naming_strategy"></a> [naming\_strategy](#input\_naming\_strategy) | How Kubernetes object names are built: 'ids' (e.g. d-123456-789012), 'qualified' (application and scope slugs) or 'custom' (the naming patterns). Existing objects are never renamed. Defaults to 'ids' when unset | `string` | `""` | no |
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
  "description": "Configures a GKE provider configuration in Nullplatform by creating a nullplatform_provider_config resource with cluster, gateway, traffic manager, and naming settings",
  "architecture": "The module constructs a single nullplatform_provider_config resource of type 'gke-configuration' by merging multiple local maps (gateway, resource_management, security, naming) into a JSON-encoded attributes payload. Input variables for cluster identity (cluster_name, location), gateway routing (public_gateway_name, private_gateway_name, additional_public_gateways, additional_private_gateways), traffic manager versioning, and Kubernetes naming strategy are composed into nested locals before being serialized via jsonencode. The nullplatform_provider_config resource binds all configuration to the target NRN scope using the nrn and dimensions inputs, enabling Nullplatform to manage GKE workload deployments against the described cluster.",
  "features": [
    "Creates a nullplatform_provider_config resource encoding GKE cluster identity and location for Nullplatform workload management",
    "Configures public and private Kubernetes Gateway API gateway references with optional namespace and additional gateway attachments",
    "Pins traffic manager sidecar container to an explicit version tag, rejecting moving references like 'latest', 'main', or 'master'",
    "Supports flexible Kubernetes object naming strategies including id-based, slug-qualified, and fully custom pattern modes",
    "Configures resource management tuning parameters including memory-to-CPU ratio, request-to-limit ratios, and max milicores limits",
    "Manages image pull secrets and Kubernetes service account bindings for secure private container image access",
    "Applies dynamic Kubernetes object modifiers for post-render patching of cluster resources"
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
      "name": "additional_public_gateways",
      "description": "Extra gateways the HTTPRoute of public scopes is also attached to, besides the public gateway. namespace defaults to the gateway namespace. Every gateway must exist in the cluster",
      "required": false
    },
    {
      "name": "additional_private_gateways",
      "description": "Extra gateways the HTTPRoute of private scopes is also attached to, besides the private gateway. namespace defaults to the gateway namespace. Every gateway must exist in the cluster",
      "required": false
    },
    {
      "name": "naming_strategy",
      "description": "How Kubernetes object names are built: 'ids' (e.g. d-123456-789012), 'qualified' (application and scope slugs) or 'custom' (the naming patterns). Existing objects are never renamed. Defaults to 'ids' when unset",
      "required": false
    },
    {
      "name": "naming_deployment_pattern",
      "description": "Name pattern for the objects a deployment creates (Deployment, Service, HPA, Secret, PodDisruptionBudget), e.g. {.application.slug}-{.scope.slug}-{.deployment.id}. Read only when naming_strategy is 'custom'",
      "required": false
    },
    {
      "name": "naming_scope_pattern",
      "description": "Name pattern for the objects that outlive a deployment (Ingress, HTTPRoute, serving certificate), e.g. {.application.slug}-{.scope.slug}-{.scope.id}. Read only when naming_strategy is 'custom'. Only applies to scopes created after the change",
      "required": false
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
  "hash": "66e67cd1142b230e902c6d701c48748f"
}
END_AI_METADATA -->
