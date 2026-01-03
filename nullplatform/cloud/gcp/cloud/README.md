# Module: GCP Cloud

Configures nullplatform for Google Cloud by registering the project, location, networking domain.

## Usage
<!-- BEGIN_MODULE_USAGE -->

### Basic example

```hcl
module "cloud_gcp" {
  source                = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/cloud/gcp/cloud?ref=v1.0.0"
  nrn                   = var.nrn
  np_api_key            = var.np_api_key
  domain_name           = var.domain_name
  location              = var.location
  project_id            = var.project_id
  include_environment   = var.include_environment
  private_dns_zone_name = var.private_dns_zone_name
  public_dns_zone_name  = var.public_dns_zone_name
  service_account_key   = var.service_account_key
}
```

<!-- END_MODULE_USAGE -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.74 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.74 |

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
