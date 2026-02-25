# Module: dns

## Description

Creates and manages OCI DNS zones with support for primary and secondary zones, external masters, and custom tagging

## Features

- Creates multiple DNS zones in a specified OCI compartment
- Supports both PRIMARY and SECONDARY zone types
- Configures external masters for secondary zones with TSIG key support
- Manages zone scope settings (GLOBAL or PRIVATE)
- Associates zones with DNS views for private DNS
- Applies defined and freeform tags to all zones
- Outputs zone details including nameservers and metadata

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/dns?ref=v1.38.2"

  compartment_id = "your-compartment-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dns.dns_zones
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

## Resources

| Name | Type |
|------|------|
| [oci_dns_zone.zones](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/dns_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment where the DNS zone will be created | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all DNS zones | `map(string)` | `{}` | no |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | Map of DNS zones to create. Key is used as identifier. | <pre>map(object({<br/>    name          = string<br/>    zone_type     = optional(string, "PRIMARY")<br/>    scope         = optional(string, "GLOBAL")<br/>    view_id       = optional(string, null)<br/>    defined_tags  = optional(map(string), {})<br/>    freeform_tags = optional(map(string), {})<br/>    external_masters = optional(list(object({<br/>      address     = string<br/>      port        = optional(number, 53)<br/>      tsig_key_id = optional(string, null)<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all DNS zones | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zone_ids"></a> [dns\_zone\_ids](#output\_dns\_zone\_ids) | Map of DNS zone names to their OCIDs |
| <a name="output_dns_zone_nameservers"></a> [dns\_zone\_nameservers](#output\_dns\_zone\_nameservers) | Map of DNS zone names to their nameservers |
| <a name="output_dns_zones"></a> [dns\_zones](#output\_dns\_zones) | Map of created DNS zones with their details |
<!-- END_TF_DOCS -->
