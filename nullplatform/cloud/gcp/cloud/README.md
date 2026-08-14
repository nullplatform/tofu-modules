# Module: cloud

## Description

Creates a Nullplatform provider configuration for Google Cloud Platform resources

## Architecture

The module creates a single nullplatform_provider_config resource of type 'google-cloud-configuration' that stores GCP authentication, project, and networking attributes. Inputs flow directly into the attributes JSON structure, with the provider config ID and NRN exposed as outputs.

## Features

- Configures GCP project ID and location for resource deployment
- Manages public and private DNS zone names for Cloud DNS integration
- Supports application domain flag for domain-specific configurations
- Stores authentication and networking attributes in Nullplatform provider config

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/gcp/cloud?ref=v6.14.0"

  domain_name = "your-domain-name"
  location    = "your-location"
  nrn         = "your-nrn"
  project_id  = "your-project-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.cloud.provider_config_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.gcp](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_domain"></a> [application\_domain](#input\_application\_domain) | Whether this is an application domain | `bool` | `false` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the configuration | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | Name of the private DNS zone in GCP Cloud DNS | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where resources will be created | `string` | n/a | yes |
| <a name="input_public_dns_zone_name"></a> [public\_dns\_zone\_name](#input\_public\_dns\_zone\_name) | Name of the public DNS zone in GCP Cloud DNS | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | The ID of the nullplatform provider config |
| <a name="output_provider_config_nrn"></a> [provider\_config\_nrn](#output\_provider\_config\_nrn) | The NRN of the nullplatform provider config |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloud",
  "description": "Creates a Nullplatform provider configuration for Google Cloud Platform resources",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'google-cloud-configuration' that stores GCP authentication, project, and networking attributes. Inputs flow directly into the attributes JSON structure, with the provider config ID and NRN exposed as outputs.",
  "features": [
    "Configures GCP project ID and location for resource deployment",
    "Manages public and private DNS zone names for Cloud DNS integration",
    "Supports application domain flag for domain-specific configurations",
    "Stores authentication and networking attributes in Nullplatform provider config"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Identifier Nullplatform Resources Name",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "Domain name for the configuration",
      "required": true
    },
    {
      "name": "project_id",
      "description": "GCP project ID where resources will be created",
      "required": true
    },
    {
      "name": "private_dns_zone_name",
      "description": "Name of the private DNS zone in GCP Cloud DNS",
      "required": false
    },
    {
      "name": "public_dns_zone_name",
      "description": "Name of the public DNS zone in GCP Cloud DNS",
      "required": false
    },
    {
      "name": "application_domain",
      "description": "Whether this is an application domain",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Dimensions for the provider configuration",
      "required": false
    }
  ],
  "outputs": [
    "provider_config_id",
    "provider_config_nrn"
  ],
  "hash": "a90534d0ddf8af423affcf7a1d83c580"
}
END_AI_METADATA -->
