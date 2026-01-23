# Module:



## Usage

```hcl



```




<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oke"></a> [oke](#module\_oke) | oracle-terraform-modules/oke/oci | 5.3.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_endpoint_subnet_id"></a> [api\_endpoint\_subnet\_id](#input\_api\_endpoint\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_assign_public_ip_to_control_plane"></a> [assign\_public\_ip\_to\_control\_plane](#input\_assign\_public\_ip\_to\_control\_plane) | n/a | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | n/a | `string` | n/a | yes |
| <a name="input_control_plane_is_public"></a> [control\_plane\_is\_public](#input\_control\_plane\_is\_public) | n/a | `bool` | `false` | no |
| <a name="input_control_plane_nsg_ids"></a> [control\_plane\_nsg\_ids](#input\_control\_plane\_nsg\_ids) | n/a | `set(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_existing_vcn_id"></a> [existing\_vcn\_id](#input\_existing\_vcn\_id) | n/a | `string` | n/a | yes |
| <a name="input_home_region"></a> [home\_region](#input\_home\_region) | The tenancy's home region | `string` | n/a | yes |
| <a name="input_node_pool_subnet_id"></a> [node\_pool\_subnet\_id](#input\_node\_pool\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service_lb_subnet_id"></a> [service\_lb\_subnet\_id](#input\_service\_lb\_subnet\_id) | Subnet ID for service load balancers (typically public subnet) | `string` | n/a | yes |
| <a name="input_worker_cloud_init"></a> [worker\_cloud\_init](#input\_worker\_cloud\_init) | Cloud init configuration for worker nodes. See: https://cloudinit.readthedocs.io/en/latest/reference/modules.html | `list(map(string))` | `[]` | no |
| <a name="input_worker_pools"></a> [worker\_pools](#input\_worker\_pools) | n/a | `any` | <pre>{<br/>  "pool_principal": {<br/>    "boot_volume_size": 50,<br/>    "image_type": "platform",<br/>    "memory": 16,<br/>    "mode": "node-pool",<br/>    "ocpus": 2,<br/>    "os": "Oracle Linux",<br/>    "os_version": "8",<br/>    "shape": "VM.Standard.E4.Flex",<br/>    "size": 2<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_cert"></a> [cluster\_ca\_cert](#output\_cluster\_ca\_cert) | OKE cluster CA certificate |
| <a name="output_cluster_endpoints"></a> [cluster\_endpoints](#output\_cluster\_endpoints) | Endpoints for the OKE cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The OCID of the OKE cluster |
<!-- END_TF_DOCS -->