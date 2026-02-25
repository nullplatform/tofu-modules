# Module: vcn

## Description

Creates an Oracle Cloud Infrastructure (OCI) Virtual Cloud Network with public and private subnets, gateways, and optional OKE control plane network security group

## Features

- Creates a VCN with configurable CIDR blocks and DNS labels
- Provisions public and private subnets with dedicated route tables
- Configures Internet Gateway, NAT Gateway, and Service Gateway
- Creates optional Network Security Group for OKE control plane with customizable API endpoint access
- Implements security rules for Kubernetes API access on port 6443
- Supports internal cluster communication through VCN-wide ingress rules

## Basic Usage

```hcl
module "vcn" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/vcn?ref=v1.38.1"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.vcn.vcn_id
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
| <a name="provider_oci"></a> [oci](#provider\_oci) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vcn"></a> [vcn](#module\_vcn) | oracle-terraform-modules/vcn/oci | 3.6.0 |

## Resources

| Name | Type |
|------|------|
| [oci_core_network_security_group.oke_control_plane](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.oke_api_ingress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.oke_control_plane_egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.oke_vcn_ingress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_subnet.private_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.public_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | value | `string` | `"value"` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | value | `bool` | `true` | no |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | value | `bool` | `true` | no |
| <a name="input_create_oke_control_plane_nsg"></a> [create\_oke\_control\_plane\_nsg](#input\_create\_oke\_control\_plane\_nsg) | Whether to create an NSG for OKE control plane access | `bool` | `true` | no |
| <a name="input_create_service_gateway"></a> [create\_service\_gateway](#input\_create\_service\_gateway) | value | `bool` | `true` | no |
| <a name="input_oke_api_endpoint_allowed_cidrs"></a> [oke\_api\_endpoint\_allowed\_cidrs](#input\_oke\_api\_endpoint\_allowed\_cidrs) | List of CIDR blocks allowed to access the Kubernetes API endpoint (port 6443) | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | value | `string` | `"value"` | no |
| <a name="input_subnet_private_cidr_block"></a> [subnet\_private\_cidr\_block](#input\_subnet\_private\_cidr\_block) | value | `string` | `""` | no |
| <a name="input_subnet_private_display_name"></a> [subnet\_private\_display\_name](#input\_subnet\_private\_display\_name) | value | `string` | `"private-subnet"` | no |
| <a name="input_subnet_private_prohibit_public_ip_on_vnic"></a> [subnet\_private\_prohibit\_public\_ip\_on\_vnic](#input\_subnet\_private\_prohibit\_public\_ip\_on\_vnic) | value | `bool` | `true` | no |
| <a name="input_subnet_public_cidr_block"></a> [subnet\_public\_cidr\_block](#input\_subnet\_public\_cidr\_block) | value | `string` | `"value"` | no |
| <a name="input_subnet_public_display_name"></a> [subnet\_public\_display\_name](#input\_subnet\_public\_display\_name) | value | `string` | `"value"` | no |
| <a name="input_vcn_cidrs"></a> [vcn\_cidrs](#input\_vcn\_cidrs) | value | `list(string)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_vcn_dns_label"></a> [vcn\_dns\_label](#input\_vcn\_dns\_label) | value | `string` | `"value"` | no |
| <a name="input_vcn_name"></a> [vcn\_name](#input\_vcn\_name) | value | `string` | `"value"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_security_list_id"></a> [default\_security\_list\_id](#output\_default\_security\_list\_id) | The OCID of the default security list |
| <a name="output_ig_route_id"></a> [ig\_route\_id](#output\_ig\_route\_id) | The OCID of the Internet Gateway route table |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The OCID of the Internet Gateway |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | The OCID of the NAT Gateway |
| <a name="output_nat_route_id"></a> [nat\_route\_id](#output\_nat\_route\_id) | The OCID of the NAT Gateway route table |
| <a name="output_oke_control_plane_nsg_id"></a> [oke\_control\_plane\_nsg\_id](#output\_oke\_control\_plane\_nsg\_id) | The OCID of the OKE control plane NSG |
| <a name="output_private_subnet_cidr_block"></a> [private\_subnet\_cidr\_block](#output\_private\_subnet\_cidr\_block) | The CIDR block of the private subnet |
| <a name="output_private_subnet_display_name"></a> [private\_subnet\_display\_name](#output\_private\_subnet\_display\_name) | The display name of the private subnet |
| <a name="output_private_subnet_id"></a> [private\_subnet\_id](#output\_private\_subnet\_id) | The OCID of the private subnet |
| <a name="output_public_subnet_cidr_block"></a> [public\_subnet\_cidr\_block](#output\_public\_subnet\_cidr\_block) | The CIDR block of the public subnet |
| <a name="output_public_subnet_display_name"></a> [public\_subnet\_display\_name](#output\_public\_subnet\_display\_name) | The display name of the public subnet |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | The OCID of the public subnet |
| <a name="output_service_gateway_id"></a> [service\_gateway\_id](#output\_service\_gateway\_id) | The OCID of the Service Gateway |
| <a name="output_sgw_route_id"></a> [sgw\_route\_id](#output\_sgw\_route\_id) | The OCID of the Service Gateway route table |
| <a name="output_vcn_all_attributes"></a> [vcn\_all\_attributes](#output\_vcn\_all\_attributes) | All attributes of the VCN |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | The OCID of the VCN |
<!-- END_TF_DOCS -->
