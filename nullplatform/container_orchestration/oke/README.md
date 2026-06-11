# Module: oke

## Description

Configures an Oracle Container Engine for Kubernetes (OKE) provider in Nullplatform

## Architecture

Creates a single nullplatform_provider_config resource of type 'oke' that stores cluster metadata including cluster name, region, and gateway configuration. The module accepts required inputs for NRN, cluster name, and region, while providing defaults for Kubernetes namespaces and gateway names. All configuration is encoded as JSON attributes within the provider config resource.

## Features

- Registers OKE cluster with Nullplatform using provider configuration
- Stores cluster location and namespace mappings in centralized configuration
- Configures public and private gateway references for traffic routing
- Supports custom dimensions for provider-level tagging and organization

## Basic Usage

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/oke?ref=v4.3.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.86 |

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
| <a name="input_namespace_application_default"></a> [namespace\_application\_default](#input\_namespace\_application\_default) | Default Kubernetes namespace for applications | `string` | `"nullplatform"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z) | `string` | n/a | yes |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private gateway | `string` | `"private-gateway"` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public gateway | `string` | `"public-gateway"` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI region where the OKE cluster is deployed | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "oke",
  "description": "Configures an Oracle Container Engine for Kubernetes (OKE) provider in Nullplatform",
  "architecture": "Creates a single nullplatform_provider_config resource of type 'oke' that stores cluster metadata including cluster name, region, and gateway configuration. The module accepts required inputs for NRN, cluster name, and region, while providing defaults for Kubernetes namespaces and gateway names. All configuration is encoded as JSON attributes within the provider config resource.",
  "features": [
    "Registers OKE cluster with Nullplatform using provider configuration",
    "Stores cluster location and namespace mappings in centralized configuration",
    "Configures public and private gateway references for traffic routing",
    "Supports custom dimensions for provider-level tagging and organization"
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
  "hash": "060984ac5758589ac80ed5c25e610c35"
}
END_AI_METADATA -->
