# Module: aks

## Description

Configures a Nullplatform AKS provider by creating a nullplatform_provider_config resource that registers cluster, gateway, traffic manager, naming, and resource management settings for an Azure Kubernetes Service cluster

## Architecture

The module constructs a set of nested locals that merge optional inputs into structured attribute maps for cluster identity, gateway routing, resource management, security, and naming configuration. A single nullplatform_provider_config resource of type 'aks-configuration' is created, binding the NRN and optional dimensions to the JSON-encoded attributes map. Inputs such as cluster_name, resource_group, public_gateway_name, and traffic_manager_version flow directly into the attributes payload, while optional inputs like private_gateway_name, additional_public_gateways, and naming_strategy are conditionally included only when non-empty. The resulting provider config registers the AKS cluster with the Nullplatform control plane so it can schedule and route workloads.

## Features

- Creates a nullplatform_provider_config resource that registers an AKS cluster with the Nullplatform control plane
- Configures public and optional private Application Gateway references with DNS-validated name constraints
- Supports additional public and private gateway attachments for multi-gateway HTTPRoute fan-out
- Pins the traffic manager sidecar container to an explicit, immutable version tag
- Configures Kubernetes object naming strategy with ids, qualified, or custom pattern modes
- Applies optional resource management tuning including memory-to-CPU ratio, request-to-limit ratio, and millicore limits
- Supports image pull secrets and a custom Kubernetes service account for deployment workloads

## Basic Usage

```hcl
module "aks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/aks?ref=v9.14.0"

  cluster_name            = "your-cluster-name"
  nrn                     = "your-nrn"
  public_gateway_name     = "your-public-gateway-name"
  resource_group          = "your-resource-group"
  traffic_manager_version = "your-traffic-manager-version"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.aks.id
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
| [nullplatform_provider_config.aks_config](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_private_gateways"></a> [additional\_private\_gateways](#input\_additional\_private\_gateways) | Extra gateways the HTTPRoute of private scopes is also attached to, besides the private gateway. namespace defaults to the gateway namespace. Every gateway must exist in the cluster | <pre>list(object({<br/>    name      = string<br/>    namespace = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_public_gateways"></a> [additional\_public\_gateways](#input\_additional\_public\_gateways) | Extra gateways the HTTPRoute of public scopes is also attached to, besides the public gateway. namespace defaults to the gateway namespace. Every gateway must exist in the cluster | <pre>list(object({<br/>    name      = string<br/>    namespace = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | The type of authentication used to connect the cluster (localAccounts, azureActiveDirectory, localandAAD) | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the AKS cluster | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_gateway_namespace"></a> [gateway\_namespace](#input\_gateway\_namespace) | Kubernetes namespace where the gateway is deployed | `string` | `"istio-ingress"` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | List of secret names to use image pull secrets | `list(string)` | `[]` | no |
| <a name="input_max_cores_multiplier"></a> [max\_cores\_multiplier](#input\_max\_cores\_multiplier) | Sets the ratio between requested and limit CPU. Default value is 3, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_max_milicores"></a> [max\_milicores](#input\_max\_milicores) | Sets the maximum amount of CPU mili cores a pod can use | `string` | `""` | no |
| <a name="input_memory_cpu_ratio"></a> [memory\_cpu\_ratio](#input\_memory\_cpu\_ratio) | Amount of MiB of ram per CPU. Default value is 2048, it means 1 core for every 2 GiB of RAM | `string` | `""` | no |
| <a name="input_memory_request_to_limit_ratio"></a> [memory\_request\_to\_limit\_ratio](#input\_memory\_request\_to\_limit\_ratio) | Sets the ratio between requested and limit memory. Default value is 1, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_namespace_application_default"></a> [namespace\_application\_default](#input\_namespace\_application\_default) | Default Kubernetes namespace for applications. Accepts a pattern the k8s scope renders per scope, e.g. {.namespace.slug} for one Kubernetes namespace per nullplatform namespace | `string` | `"nullplatform"` | no |
| <a name="input_naming_deployment_pattern"></a> [naming\_deployment\_pattern](#input\_naming\_deployment\_pattern) | Name pattern for the objects a deployment creates (Deployment, Service, HPA, Secret, PodDisruptionBudget), e.g. {.application.slug}-{.scope.slug}-{.deployment.id}. Read only when naming\_strategy is 'custom' | `string` | `""` | no |
| <a name="input_naming_scope_pattern"></a> [naming\_scope\_pattern](#input\_naming\_scope\_pattern) | Name pattern for the objects that outlive a deployment (Ingress, HTTPRoute, serving certificate), e.g. {.application.slug}-{.scope.slug}-{.scope.id}. Read only when naming\_strategy is 'custom'. Only applies to scopes created after the change | `string` | `""` | no |
| <a name="input_naming_strategy"></a> [naming\_strategy](#input\_naming\_strategy) | How Kubernetes object names are built: 'ids' (e.g. d-123456-789012), 'qualified' (application and scope slugs) or 'custom' (the naming patterns). Existing objects are never renamed. Defaults to 'qualified' | `string` | `"qualified"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z) | `string` | n/a | yes |
| <a name="input_object_modifiers"></a> [object\_modifiers](#input\_object\_modifiers) | List of modifications to dynamically modify k8s objects | <pre>list(object({<br/>    selector = string<br/>    action   = string<br/>    type     = string<br/>    value    = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private Application Gateway in AKS | `string` | `""` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public Application Gateway in AKS | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Name of the resource group containing the AKS cluster | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The name of the Kubernetes service account used for deployments | `string` | `""` | no |
| <a name="input_traffic_manager_version"></a> [traffic\_manager\_version](#input\_traffic\_manager\_version) | No default: every install pins this deliberately — see VERSIONS.md. Tag for the traffic manager sidecar container | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "aks",
  "description": "Configures a Nullplatform AKS provider by creating a nullplatform_provider_config resource that registers cluster, gateway, traffic manager, naming, and resource management settings for an Azure Kubernetes Service cluster",
  "architecture": "The module constructs a set of nested locals that merge optional inputs into structured attribute maps for cluster identity, gateway routing, resource management, security, and naming configuration. A single nullplatform_provider_config resource of type 'aks-configuration' is created, binding the NRN and optional dimensions to the JSON-encoded attributes map. Inputs such as cluster_name, resource_group, public_gateway_name, and traffic_manager_version flow directly into the attributes payload, while optional inputs like private_gateway_name, additional_public_gateways, and naming_strategy are conditionally included only when non-empty. The resulting provider config registers the AKS cluster with the Nullplatform control plane so it can schedule and route workloads.",
  "features": [
    "Creates a nullplatform_provider_config resource that registers an AKS cluster with the Nullplatform control plane",
    "Configures public and optional private Application Gateway references with DNS-validated name constraints",
    "Supports additional public and private gateway attachments for multi-gateway HTTPRoute fan-out",
    "Pins the traffic manager sidecar container to an explicit, immutable version tag",
    "Configures Kubernetes object naming strategy with ids, qualified, or custom pattern modes",
    "Applies optional resource management tuning including memory-to-CPU ratio, request-to-limit ratio, and millicore limits",
    "Supports image pull secrets and a custom Kubernetes service account for deployment workloads"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z)",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "The name of the AKS cluster",
      "required": true
    },
    {
      "name": "resource_group",
      "description": "Name of the resource group containing the AKS cluster",
      "required": true
    },
    {
      "name": "public_gateway_name",
      "description": "Name of the public Application Gateway in AKS",
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
      "description": "Name of the private Application Gateway in AKS",
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
      "description": "How Kubernetes object names are built: 'ids' (e.g. d-123456-789012), 'qualified' (application and scope slugs) or 'custom' (the naming patterns). Existing objects are never renamed. Defaults to 'qualified'",
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
      "description": "Default Kubernetes namespace for applications. Accepts a pattern the k8s scope renders per scope, e.g. {.namespace.slug} for one Kubernetes namespace per nullplatform namespace",
      "required": false
    },
    {
      "name": "authentication_mode",
      "description": "The type of authentication used to connect the cluster (localAccounts, azureActiveDirectory, localandAAD)",
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
      "description": "List of secret names to use image pull secrets",
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
  "hash": "89ac1fd90dc1c9b3e28700220c7586f2"
}
END_AI_METADATA -->
