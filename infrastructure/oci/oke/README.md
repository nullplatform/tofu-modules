# Module: oke

## Description

Provisions an Oracle Container Engine for Kubernetes (OKE) cluster with enhanced networking, optional OCIR integration, and workload identity support

## Features

- Creates an enhanced OKE cluster with Kubernetes v1.34.1 and Flannel CNI
- Configures cluster networking using existing VCN and subnets for control plane, workers, and load balancers
- Supports flexible worker pool configuration with customizable shapes, sizes, and boot volumes
- Enables OIDC discovery for Workload Identity authentication
- Provides optional OCIR pull access with dual authentication methods (Instance Principal and Workload Identity)
- Deploys OKE credential provider for seamless private container image pulls from OCIR
- Creates IAM policies and dynamic groups for worker node and pod-level OCIR access

## Basic Usage

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/oke?ref=v1.45.0"

  api_endpoint_subnet_id = "your-api-endpoint-subnet-id"
  cluster_name           = "your-cluster-name"
  compartment_id         = "your-compartment-id"
  existing_vcn_id        = "your-existing-vcn-id"
  home_region            = "your-home-region"
  node_pool_subnet_id    = "your-node-pool-subnet-id"
  region                 = "your-region"
  service_lb_subnet_id   = "your-service-lb-subnet-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.oke.cluster_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci.home"></a> [oci.home](#provider\_oci.home) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oke"></a> [oke](#module\_oke) | oracle-terraform-modules/oke/oci | 5.3.3 |

## Resources

| Name | Type |
|------|------|
| [oci_identity_dynamic_group.ocir_nodes](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.ocir_nodes](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_policy.ocir_workload_identity](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_endpoint_subnet_id"></a> [api\_endpoint\_subnet\_id](#input\_api\_endpoint\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_assign_public_ip_to_control_plane"></a> [assign\_public\_ip\_to\_control\_plane](#input\_assign\_public\_ip\_to\_control\_plane) | n/a | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | n/a | `string` | n/a | yes |
| <a name="input_control_plane_is_public"></a> [control\_plane\_is\_public](#input\_control\_plane\_is\_public) | n/a | `bool` | `false` | no |
| <a name="input_control_plane_nsg_ids"></a> [control\_plane\_nsg\_ids](#input\_control\_plane\_nsg\_ids) | n/a | `set(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_enable_ocir_pull"></a> [enable\_ocir\_pull](#input\_enable\_ocir\_pull) | Enable IAM policy to allow workloads to pull images from OCIR | `bool` | `false` | no |
| <a name="input_existing_vcn_id"></a> [existing\_vcn\_id](#input\_existing\_vcn\_id) | n/a | `string` | n/a | yes |
| <a name="input_home_region"></a> [home\_region](#input\_home\_region) | The tenancy's home region | `string` | n/a | yes |
| <a name="input_node_pool_subnet_id"></a> [node\_pool\_subnet\_id](#input\_node\_pool\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_ocir_pull_namespaces"></a> [ocir\_pull\_namespaces](#input\_ocir\_pull\_namespaces) | List of Kubernetes namespaces allowed to pull from OCIR. If empty, all namespaces in the cluster are allowed. | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service_lb_subnet_id"></a> [service\_lb\_subnet\_id](#input\_service\_lb\_subnet\_id) | Subnet ID for service load balancers (typically public subnet) | `string` | n/a | yes |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | The tenancy OCID (required when enable\_ocir\_pull is true) | `string` | `null` | no |
| <a name="input_worker_cloud_init"></a> [worker\_cloud\_init](#input\_worker\_cloud\_init) | Cloud init configuration for worker nodes. See: https://cloudinit.readthedocs.io/en/latest/reference/modules.html | `list(map(string))` | `[]` | no |
| <a name="input_worker_pools"></a> [worker\_pools](#input\_worker\_pools) | n/a | `any` | <pre>{<br/>  "pool_principal": {<br/>    "boot_volume_size": 50,<br/>    "image_type": "platform",<br/>    "memory": 16,<br/>    "mode": "node-pool",<br/>    "ocpus": 2,<br/>    "os": "Oracle Linux",<br/>    "os_version": "8",<br/>    "shape": "VM.Standard.E4.Flex",<br/>    "size": 2<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_cert"></a> [cluster\_ca\_cert](#output\_cluster\_ca\_cert) | OKE cluster CA certificate |
| <a name="output_cluster_endpoints"></a> [cluster\_endpoints](#output\_cluster\_endpoints) | Endpoints for the OKE cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The OCID of the OKE cluster |
| <a name="output_ocir_credential_provider_cloud_init"></a> [ocir\_credential\_provider\_cloud\_init](#output\_ocir\_credential\_provider\_cloud\_init) | Cloud-init script to install OCIR credential provider on worker nodes (if enabled) |
| <a name="output_ocir_dynamic_group_id"></a> [ocir\_dynamic\_group\_id](#output\_ocir\_dynamic\_group\_id) | The OCID of the OCIR nodes dynamic group (if enabled) |
| <a name="output_ocir_kubelet_extra_args"></a> [ocir\_kubelet\_extra\_args](#output\_ocir\_kubelet\_extra\_args) | Extra kubelet arguments needed for OCIR credential provider |
| <a name="output_ocir_nodes_policy_id"></a> [ocir\_nodes\_policy\_id](#output\_ocir\_nodes\_policy\_id) | The OCID of the OCIR nodes policy (if enabled) |
| <a name="output_ocir_policy_statements"></a> [ocir\_policy\_statements](#output\_ocir\_policy\_statements) | All OCIR policy statements (if enabled) |
| <a name="output_ocir_workload_policy_id"></a> [ocir\_workload\_policy\_id](#output\_ocir\_workload\_policy\_id) | The OCID of the OCIR workload identity policy (if enabled) |
<!-- END_TF_DOCS -->
