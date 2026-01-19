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

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | value |
<!-- END_TF_DOCS -->