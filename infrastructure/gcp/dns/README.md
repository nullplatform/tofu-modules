# Module: dns

## Description

Creates and manages a Google Cloud DNS managed zone with support for both public and private visibility configurations

## Features

- Creates a Google Cloud DNS managed zone with configurable visibility
- Supports both public and private DNS zone configurations
- Enables private DNS zone association with multiple VPC networks
- Configures custom DNS zone naming or generates from domain name
- Applies custom labels for resource tagging and organization
- Outputs zone details including name servers for DNS delegation

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/dns?ref=v1.38.1"

  domain_name = "your-domain-name"
  project_id  = "your-project-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dns.dns_zone_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone.zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The name of the DNS zone resource (defaults to domain name with dashes) | `string` | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to use for the DNS zone (e.g., example.com) | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of labels to assign to the DNS zone | `map(string)` | `{}` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Zone visibility: public or private | `string` | `"public"` | no |
| <a name="input_vpc_ids"></a> [vpc\_ids](#input\_vpc\_ids) | Vpc self-links for private DNS zone association | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | The ID of the created DNS zone |
| <a name="output_dns_zone_name"></a> [dns\_zone\_name](#output\_dns\_zone\_name) | The name of the created DNS zone |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | The list of name servers for the DNS zone |
<!-- END_TF_DOCS -->
