# Module: Container orchestration for OKE

## Description

This Terraform module configures Oracle Kubernetes Engine (OKE) as a container orchestration provider in nullplatform. It creates the necessary provider configuration to enable nullplatform to deploy and manage applications on an existing OKE cluster.

The module sets up:
- **Cluster configuration**: Connects nullplatform to your OKE cluster by specifying the cluster name, default application namespace, and OCI region.
- **Gateway configuration**: Configures public and private gateway names used for routing traffic to your applications.

This module should be used after setting up the OCI cloud provider configuration (`nullplatform/cloud/oci`).

## Usage



```hcl
 module "oke" {

    source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/oke?ref=feature/ocicloud"

    depends_on = [module.name]

    nrn        = "organization=xxx:account=xxx:namespace=xxx"
    dimension  = {}
    cluster_name                  = "oke-cluster-nullplatform"
    namespace_application_default = "nullplatform"
    region                        = "us-ashburn-1"

    gateway_namespace    = "gateways"
    public_gateway_name  = "public-gateway"
    private_gateway_name = "private-gateway"
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
