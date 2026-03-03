# Module: oke

## Description

Configures Nullplatform provider settings for Oracle Kubernetes Engine (OKE) clusters

## Features

- Creates a Nullplatform provider configuration for OKE clusters
- Configures cluster identification and location attributes
- Defines gateway settings for public and private access
- Supports custom dimensions for provider configuration
- Maps OCI region to cluster location
- Configures default Kubernetes namespace for applications
- Manages gateway namespace and naming conventions

## Basic Usage

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/oke?ref=v1.41.1"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

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
