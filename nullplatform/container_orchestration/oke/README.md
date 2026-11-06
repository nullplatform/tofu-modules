# Module: oke

## Description

Configures a Nullplatform OKE (Oracle Kubernetes Engine) provider by registering cluster, gateway, and naming settings via a nullplatform_provider_config resource

## Architecture

The module creates a single nullplatform_provider_config resource of type 'oke' that encodes cluster identity (name, namespace, region), gateway configuration (namespace, public and private gateway names), and an optional naming block into a JSON attributes payload. Local values filter out empty naming fields so only explicitly set naming options are included in the encoded attributes. The nrn variable scopes the provider config to a specific Nullplatform organizational hierarchy, while dimensions allow additional metadata tagging of the provider record.

## Features

- Creates a nullplatform_provider_config resource of type 'oke' linking an OKE cluster to a Nullplatform NRN hierarchy
- Encodes cluster identity including name, default application namespace, and OCI region into the provider attributes
- Configures gateway settings with separate public and private gateway names and a dedicated gateway namespace
- Supports flexible Kubernetes object naming strategies including id-based, qualified slug-based, and fully custom pattern modes
- Applies custom deployment-scoped and scope-scoped naming patterns with length and character validation
- Accepts arbitrary dimensions map for additional provider configuration metadata

## Basic Usage

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/oke?ref=v9.11.2"

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
| <a name="input_naming_strategy"></a> [naming\_strategy](#input\_naming\_strategy) | How Kubernetes object names are built: 'ids' (e.g. d-123456-789012), 'qualified' (application and scope slugs) or 'custom' (the naming patterns). Existing objects are never renamed. Defaults to 'ids' when unset | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z) | `string` | n/a | yes |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private gateway | `string` | `"private-gateway"` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public gateway | `string` | `"public-gateway"` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI region where the OKE cluster is deployed | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "oke",
  "description": "Configures a Nullplatform OKE (Oracle Kubernetes Engine) provider by registering cluster, gateway, and naming settings via a nullplatform_provider_config resource",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'oke' that encodes cluster identity (name, namespace, region), gateway configuration (namespace, public and private gateway names), and an optional naming block into a JSON attributes payload. Local values filter out empty naming fields so only explicitly set naming options are included in the encoded attributes. The nrn variable scopes the provider config to a specific Nullplatform organizational hierarchy, while dimensions allow additional metadata tagging of the provider record.",
  "features": [
    "Creates a nullplatform_provider_config resource of type 'oke' linking an OKE cluster to a Nullplatform NRN hierarchy",
    "Encodes cluster identity including name, default application namespace, and OCI region into the provider attributes",
    "Configures gateway settings with separate public and private gateway names and a dedicated gateway namespace",
    "Supports flexible Kubernetes object naming strategies including id-based, qualified slug-based, and fully custom pattern modes",
    "Applies custom deployment-scoped and scope-scoped naming patterns with length and character validation",
    "Accepts arbitrary dimensions map for additional provider configuration metadata"
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
  "hash": "0a8ff980d1ec96dcadfbc8b9ac1b4058"
}
END_AI_METADATA -->
