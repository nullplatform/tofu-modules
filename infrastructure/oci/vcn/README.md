# Module:



## Usage

```hcl



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
| [oci_core_subnet.private_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.public_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | value | `string` | `"value"` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | value | `bool` | `true` | no |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | value | `bool` | `true` | no |
| <a name="input_create_service_gateway"></a> [create\_service\_gateway](#input\_create\_service\_gateway) | value | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | value | `string` | `"value"` | no |
| <a name="input_subnet_private_cidr_block"></a> [subnet\_private\_cidr\_block](#input\_subnet\_private\_cidr\_block) | value | `string` | `""` | no |
| <a name="input_subnet_private_display_name"></a> [subnet\_private\_display\_name](#input\_subnet\_private\_display\_name) | value | `string` | `"private-subnet"` | no |
| <a name="input_subnet_private_prohibit_public_ip_on_vnic"></a> [subnet\_private\_prohibit\_public\_ip\_on\_vnic](#input\_subnet\_private\_prohibit\_public\_ip\_on\_vnic) | value | `bool` | `true` | no |
| <a name="input_subnet_public_cidr_block"></a> [subnet\_public\_cidr\_block](#input\_subnet\_public\_cidr\_block) | value | `string` | `"value"` | no |
| <a name="input_subnet_public_display_name"></a> [subnet\_public\_display\_name](#input\_subnet\_public\_display\_name) | value | `string` | `"value"` | no |
| <a name="input_vcn_cidrs"></a> [vcn\_cidrs](#input\_vcn\_cidrs) | value | `list(string)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_vcn_dns_label"></a> [vcn\_dns\_label](#input\_vcn\_dns\_label) | value | `string` | `"value"` | no |
| <a name="input_vcn_name"></a> [vcn\_name](#input\_vcn\_name) | value | `string` | `"value"` | no |
<!-- END_TF_DOCS -->