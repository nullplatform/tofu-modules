# Module: dns

## Description

Creates and manages DNS zones in Oracle Cloud Infrastructure

## Architecture

This module creates oci_dns_zone resources for each DNS zone defined in the dns_zones variable, connecting them to the specified compartment and applying defined and freeform tags. The oci_dns_zone resources are configured with the provided zone type, scope, and view ID, and are connected to external masters if specified. The module also outputs the created DNS zones, their IDs, and their nameservers.

## Features

- Creates DNS zones with primary and secondary zone types
- Configures DNS zones with custom scopes and view IDs
- Applies defined and freeform tags to DNS zones

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/dns?ref=v2.0.0"

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
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.29.0 |

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

<!-- BEGIN_AI_METADATA
{
  "name": "dns",
  "description": "Creates and manages DNS zones in Oracle Cloud Infrastructure",
  "architecture": "This module creates oci_dns_zone resources for each DNS zone defined in the dns_zones variable, connecting them to the specified compartment and applying defined and freeform tags. The oci_dns_zone resources are configured with the provided zone type, scope, and view ID, and are connected to external masters if specified. The module also outputs the created DNS zones, their IDs, and their nameservers.",
  "features": [
    "Creates DNS zones with primary and secondary zone types",
    "Configures DNS zones with custom scopes and view IDs",
    "Applies defined and freeform tags to DNS zones"
  ],
  "inputs": [
    {
      "name": "compartment_id",
      "description": "The OCID of the compartment where the DNS zone will be created",
      "required": true
    },
    {
      "name": "dns_zones",
      "description": "Map of DNS zones to create. Key is used as identifier.",
      "required": false
    },
    {
      "name": "defined_tags",
      "description": "Defined tags to apply to all DNS zones",
      "required": false
    },
    {
      "name": "freeform_tags",
      "description": "Freeform tags to apply to all DNS zones",
      "required": false
    }
  ],
  "outputs": [
    "dns_zones",
    "dns_zone_ids",
    "dns_zone_nameservers"
  ],
  "hash": "ec0cdc9b17236b8f372078036b6d3a5b"
}
END_AI_METADATA -->
