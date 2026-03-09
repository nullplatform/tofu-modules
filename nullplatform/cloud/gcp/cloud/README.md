# Module: cloud

## Description

Configures a Nullplatform provider for Google Cloud Platform with networking and DNS settings

## Features

- Creates a Nullplatform provider configuration for GCP
- Configures GCP project and location settings
- Manages domain name and DNS zone configuration
- Supports both public and private DNS zones
- Enables application domain configuration
- Provides customizable dimensions for the provider
- Ignores changes to attributes after initial creation

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/gcp/cloud?ref=v1.43.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

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
| <a name="input_location"></a> [location](#input\_location) | GCP location/region where resources will be deployed | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | Name of the private DNS zone in GCP Cloud DNS | `string` | `""` | no |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | Private domain name | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where resources will be created | `string` | n/a | yes |
| <a name="input_public_dns_zone_name"></a> [public\_dns\_zone\_name](#input\_public\_dns\_zone\_name) | Name of the public DNS zone in GCP Cloud DNS | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | The ID of the nullplatform provider config |
| <a name="output_provider_config_nrn"></a> [provider\_config\_nrn](#output\_provider\_config\_nrn) | The NRN of the nullplatform provider config |
<!-- END_TF_DOCS -->
