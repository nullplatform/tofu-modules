# Module: cloud-dns

## Description

Creates and manages a Google Cloud DNS managed zone with support for both public and private visibility configurations

## Features

- Creates a Google Cloud DNS managed zone with configurable visibility
- Supports both public and private DNS zone configurations
- Configures private zone visibility with VPC network associations
- Manages DNS zone naming and domain configuration
- Outputs zone name and name servers for delegation
- Provides dynamic configuration for private zone network access

## Basic Usage

```hcl
module "cloud-dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/cloud-dns?ref=v1.42.0"

  domain_name = local.domain_name
  project_id  = var.project_id
  zone_name   = var.zone_name
}
```

## Using Outputs

```hcl
# zone_name is consumed by cert_manager and external_dns modules for DNS config.
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
