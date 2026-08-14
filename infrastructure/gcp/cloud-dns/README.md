# Module: cloud-dns

## Description

Creates a Google Cloud DNS managed zone with configurable public or private visibility, optional DNSSEC, and VPC network associations

## Architecture

The module creates a single google_dns_managed_zone resource in the specified GCP project, using the domain_name input as the DNS name and an auto-derived or explicitly provided zone_name. A dynamic dnssec_config block is conditionally injected when visibility is 'public' and dnssec_enabled is true, while a dynamic private_visibility_config block is injected with VPC network URLs when visibility is 'private'. The zone name, ID, and name server list are exposed as outputs for use in parent modules or DNS delegation workflows.

## Features

- Creates a google_dns_managed_zone with auto-derived zone name from domain by replacing dots with dashes
- Enables DNSSEC on public zones via dynamic dnssec_config block when dnssec_enabled is true
- Associates private zones with one or more VPC networks via dynamic private_visibility_config networks blocks
- Supports public or private zone visibility to control DNS resolution scope
- Attaches user-defined labels to the managed zone for resource organization
- Outputs name servers for use in domain registrar delegation or parent zone NS records

## Basic Usage

```hcl
module "cloud-dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/cloud-dns?ref=v6.14.0"

  domain_name = "your-domain-name"
  project_id  = "your-project-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.cloud-dns.zone_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.50.0 |

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone.zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dnssec_enabled"></a> [dnssec\_enabled](#input\_dnssec\_enabled) | Enable DNSSEC for the zone. Only applies to public zones; signing is inert until the DS record is published at the domain registrar. | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name for the DNS zone (without trailing dot, e.g. example.com) | `string` | n/a | yes |
| <a name="input_private_zone_networks"></a> [private\_zone\_networks](#input\_private\_zone\_networks) | VPC network self-links for private zones | `list(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of labels to assign to the DNS managed zone | `map(string)` | `{}` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Zone visibility: public or private | `string` | `"public"` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | The name of the DNS zone resource. Defaults to domain\_name with dots replaced by dashes. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | The list of name servers for the DNS managed zone |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The ID of the created DNS managed zone |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | The name of the created DNS managed zone |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloud-dns",
  "description": "Creates a Google Cloud DNS managed zone with configurable public or private visibility, optional DNSSEC, and VPC network associations",
  "architecture": "The module creates a single google_dns_managed_zone resource in the specified GCP project, using the domain_name input as the DNS name and an auto-derived or explicitly provided zone_name. A dynamic dnssec_config block is conditionally injected when visibility is 'public' and dnssec_enabled is true, while a dynamic private_visibility_config block is injected with VPC network URLs when visibility is 'private'. The zone name, ID, and name server list are exposed as outputs for use in parent modules or DNS delegation workflows.",
  "features": [
    "Creates a google_dns_managed_zone with auto-derived zone name from domain by replacing dots with dashes",
    "Enables DNSSEC on public zones via dynamic dnssec_config block when dnssec_enabled is true",
    "Associates private zones with one or more VPC networks via dynamic private_visibility_config networks blocks",
    "Supports public or private zone visibility to control DNS resolution scope",
    "Attaches user-defined labels to the managed zone for resource organization",
    "Outputs name servers for use in domain registrar delegation or parent zone NS records"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "The domain name for the DNS zone (without trailing dot, e.g. example.com)",
      "required": true
    },
    {
      "name": "zone_name",
      "description": "The name of the DNS zone resource. Defaults to domain_name with dots replaced by dashes.",
      "required": false
    },
    {
      "name": "visibility",
      "description": "Zone visibility: public or private",
      "required": false
    },
    {
      "name": "private_zone_networks",
      "description": "VPC network self-links for private zones",
      "required": false
    },
    {
      "name": "dnssec_enabled",
      "description": "Enable DNSSEC for the zone. Only applies to public zones; signing is inert until the DS record is published at the domain registrar.",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of labels to assign to the DNS managed zone",
      "required": false
    }
  ],
  "outputs": [
    "zone_name",
    "zone_id",
    "name_servers"
  ],
  "hash": "436e36dccc6c0a443cdffe5f6fea4c60"
}
END_AI_METADATA -->
