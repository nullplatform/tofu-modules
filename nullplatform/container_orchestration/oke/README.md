# Module: oke

## Description

Configures a Nullplatform OKE (Oracle Kubernetes Engine) provider configuration resource with cluster, gateway, and Kubernetes object naming settings

## Architecture

The module creates a single nullplatform_provider_config resource of type 'oke' that encodes cluster connection details, gateway configuration, and optional naming strategy into a JSON attributes payload. Input variables for cluster name, region, namespace, and gateway settings are merged into a structured jsonencode() call, with naming fields conditionally included only when non-empty. The dimensions variable allows arbitrary key-value metadata to be attached to the provider configuration. No additional Terraform resource types or data sources are used; all configuration flows directly into the nullplatform_provider_config attributes.

## Features

- Creates a nullplatform_provider_config resource of type 'oke' linking an OKE cluster by name and OCI region
- Configures default Kubernetes namespace for applications with support for dynamic scope-rendered patterns
- Configures public and private gateway references including their Kubernetes namespace and names
- Supports three Kubernetes object naming strategies: ids, qualified, and custom pattern-based naming
- Applies custom naming patterns for deployment-scoped objects (Deployment, Service, HPA, Secret, PodDisruptionBudget) and scope-scoped objects (Ingress, HTTPRoute, certificates)
- Conditionally omits naming configuration from the attributes payload when no naming fields are specified

## Basic Usage

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/oke?ref=v9.15.0"

  cluster_name = "your-cluster-name"
  nrn          = "your-nrn"
  region       = "your-region"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.oke.id
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
| [nullplatform_provider_config.oke_config](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | OKE cluster name | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_gateway_namespace"></a> [gateway\_namespace](#input\_gateway\_namespace) | Kubernetes namespace where the gateway is deployed | `string` | `"gateways"` | no |
| <a name="input_namespace_application_default"></a> [namespace\_application\_default](#input\_namespace\_application\_default) | Default Kubernetes namespace for applications. Accepts a pattern the k8s scope renders per scope, e.g. {.namespace.slug} for one Kubernetes namespace per nullplatform namespace | `string` | `"nullplatform"` | no |
| <a name="input_naming_deployment_pattern"></a> [naming\_deployment\_pattern](#input\_naming\_deployment\_pattern) | Name pattern for the objects a deployment creates (Deployment, Service, HPA, Secret, PodDisruptionBudget), e.g. {.application.slug}-{.scope.slug}-{.deployment.id}. Read only when naming\_strategy is 'custom' | `string` | `""` | no |
| <a name="input_naming_scope_pattern"></a> [naming\_scope\_pattern](#input\_naming\_scope\_pattern) | Name pattern for the objects that outlive a deployment (Ingress, HTTPRoute, serving certificate), e.g. {.application.slug}-{.scope.slug}-{.scope.id}. Read only when naming\_strategy is 'custom'. Only applies to scopes created after the change | `string` | `""` | no |
| <a name="input_naming_strategy"></a> [naming\_strategy](#input\_naming\_strategy) | How Kubernetes object names are built: 'ids' (e.g. d-123456-789012), 'qualified' (application and scope slugs) or 'custom' (the naming patterns). Existing objects are never renamed. Defaults to 'qualified' | `string` | `"qualified"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z) | `string` | n/a | yes |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private gateway | `string` | `"private-gateway"` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public gateway | `string` | `"public-gateway"` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI region where the OKE cluster is deployed | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "oke",
  "description": "Configures a Nullplatform OKE (Oracle Kubernetes Engine) provider configuration resource with cluster, gateway, and Kubernetes object naming settings",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'oke' that encodes cluster connection details, gateway configuration, and optional naming strategy into a JSON attributes payload. Input variables for cluster name, region, namespace, and gateway settings are merged into a structured jsonencode() call, with naming fields conditionally included only when non-empty. The dimensions variable allows arbitrary key-value metadata to be attached to the provider configuration. No additional Terraform resource types or data sources are used; all configuration flows directly into the nullplatform_provider_config attributes.",
  "features": [
    "Creates a nullplatform_provider_config resource of type 'oke' linking an OKE cluster by name and OCI region",
    "Configures default Kubernetes namespace for applications with support for dynamic scope-rendered patterns",
    "Configures public and private gateway references including their Kubernetes namespace and names",
    "Supports three Kubernetes object naming strategies: ids, qualified, and custom pattern-based naming",
    "Applies custom naming patterns for deployment-scoped objects (Deployment, Service, HPA, Secret, PodDisruptionBudget) and scope-scoped objects (Ingress, HTTPRoute, certificates)",
    "Conditionally omits naming configuration from the attributes payload when no naming fields are specified"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z)",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "OKE cluster name",
      "required": true
    },
    {
      "name": "region",
      "description": "OCI region where the OKE cluster is deployed",
      "required": true
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
      "name": "gateway_namespace",
      "description": "Kubernetes namespace where the gateway is deployed",
      "required": false
    },
    {
      "name": "public_gateway_name",
      "description": "Name of the public gateway",
      "required": false
    },
    {
      "name": "private_gateway_name",
      "description": "Name of the private gateway",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "fd51b85b010a1a67cd241c9cba590084"
}
END_AI_METADATA -->
