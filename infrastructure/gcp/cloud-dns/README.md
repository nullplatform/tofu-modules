# Module: cloud-dns

## Description

Creates a Google Cloud DNS managed zone with specified visibility and networks

## Architecture

This module creates a google_dns_managed_zone resource with the specified project ID, zone name, and domain name. The zone's visibility is set based on the provided visibility variable, and if set to private, it configures the private_visibility_config block with the specified private_zone_networks. The module also outputs the zone's name and name servers. The visibility variable controls the creation of the private_visibility_config block, which in turn depends on the private_zone_networks variable.

## Features

- Creates Google Cloud DNS managed zone with public or private visibility
- Configures private zone networks using VPC self-links
- Outputs zone name and name servers

## Basic Usage

```hcl
module "cloud-dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/cloud-dns?ref=v1.52.2"

  domain_name = "your-domain-name"
  project_id  = "your-project-id"
  zone_name   = "your-zone-name"
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
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0, < 7.0 |

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone.zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name (without trailing dot) | `string` | n/a | yes |
| <a name="input_private_zone_networks"></a> [private\_zone\_networks](#input\_private\_zone\_networks) | VPC network self-links for private zones | `list(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Zone visibility: public or private | `string` | `"public"` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | The name of the DNS zone resource | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | n/a |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | n/a |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloud-dns",
  "description": "Creates a Google Cloud DNS managed zone with specified visibility and networks",
  "architecture": "This module creates a google_dns_managed_zone resource with the specified project ID, zone name, and domain name. The zone's visibility is set based on the provided visibility variable, and if set to private, it configures the private_visibility_config block with the specified private_zone_networks. The module also outputs the zone's name and name servers. The visibility variable controls the creation of the private_visibility_config block, which in turn depends on the private_zone_networks variable.",
  "features": [
    "Creates Google Cloud DNS managed zone with public or private visibility",
    "Configures private zone networks using VPC self-links",
    "Outputs zone name and name servers"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "zone_name",
      "description": "The name of the DNS zone resource",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "The domain name (without trailing dot)",
      "required": true
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
    }
  ],
  "outputs": [
    "zone_name",
    "name_servers"
  ],
  "hash": "2fc3540a628ef019623822f1d4473bfa"
}
END_AI_METADATA -->
