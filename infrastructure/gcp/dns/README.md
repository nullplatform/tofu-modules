# Module: dns

## Description

Creates a Google Cloud DNS managed zone with optional private visibility and VPC association

## Architecture

The module creates a google_dns_managed_zone resource, which is configured with the provided project ID, domain name, and visibility settings. The zone's name is determined by the dns_zone_name variable, or defaults to the domain name with dashes if not provided. The module also supports private DNS zones by associating VPCs using the vpc_ids variable. The google_dns_managed_zone resource is further configured with labels using the tags variable. The module outputs the created DNS zone's name, ID, and name servers.

## Features

- Creates a Google Cloud DNS managed zone
- Configures private DNS zone visibility with VPC association
- Supports custom DNS zone names and labels

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/dns?ref=v1.52.2"

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

<!-- BEGIN_AI_METADATA
{
  "name": "dns",
  "description": "Creates a Google Cloud DNS managed zone with optional private visibility and VPC association",
  "architecture": "The module creates a google_dns_managed_zone resource, which is configured with the provided project ID, domain name, and visibility settings. The zone's name is determined by the dns_zone_name variable, or defaults to the domain name with dashes if not provided. The module also supports private DNS zones by associating VPCs using the vpc_ids variable. The google_dns_managed_zone resource is further configured with labels using the tags variable. The module outputs the created DNS zone's name, ID, and name servers.",
  "features": [
    "Creates a Google Cloud DNS managed zone",
    "Configures private DNS zone visibility with VPC association",
    "Supports custom DNS zone names and labels"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "The domain name to use for the DNS zone (e.g., example.com)",
      "required": true
    },
    {
      "name": "dns_zone_name",
      "description": "The name of the DNS zone resource (defaults to domain name with dashes)",
      "required": false
    },
    {
      "name": "visibility",
      "description": "Zone visibility: public or private",
      "required": false
    },
    {
      "name": "vpc_ids",
      "description": "Vpc self-links for private DNS zone association",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of labels to assign to the DNS zone",
      "required": false
    }
  ],
  "outputs": [
    "dns_zone_name",
    "dns_zone_id",
    "name_servers"
  ],
  "hash": "936faa98633e15eed17b985b6728dd72"
}
END_AI_METADATA -->
