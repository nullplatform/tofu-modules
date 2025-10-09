# Module: GCP Cloud

Configures Nullplatform for Google Cloud by registering the project, location, networking domain, and optional environment dimensions.

Usage:

```
module "cloud_gcp" {
  source                = "git@github.com:nullplatform/tofu-modules.git//nullplatform/cloud/gcp/cloud?ref=v0.0.1"
  nrn                   = var.nrn
  np_api_key            = var.np_api_key
  domain_name           = var.domain_name
  location              = var.location
  project_id            = var.project_id
  environments          = var.environments
  dimensions            = var.dimensions
  include_environment   = var.include_environment
  private_dns_zone_name = var.private_dns_zone_name
  public_dns_zone_name  = var.public_dns_zone_name
  service_account_key   = var.service_account_key
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.67 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.67 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_dimension.environment](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/dimension) | resource |
| [nullplatform_dimension_value.environment_value](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/dimension_value) | resource |
| [nullplatform_provider_config.gcp](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Map of dimension values to configure Nullplatform | `map(string)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the configuration | `string` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | The list of environments | `list(string)` | <pre>[<br/>  "development",<br/>  "staging",<br/>  "production"<br/>]</pre> | no |
| <a name="input_include_environment"></a> [include\_environment](#input\_include\_environment) | Whether to use Environment as a default dimension | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | GCP location/region where resources will be deployed | `string` | n/a | yes |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | Name of the private DNS zone in GCP Cloud DNS | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where resources will be created | `string` | n/a | yes |
| <a name="input_public_dns_zone_name"></a> [public\_dns\_zone\_name](#input\_public\_dns\_zone\_name) | Name of the public DNS zone in GCP Cloud DNS | `string` | `""` | no |
| <a name="input_service_account_key"></a> [service\_account\_key](#input\_service\_account\_key) | GCP service account key in JSON format for authentication | `string` | `""` | no |
<!-- END_TF_DOCS -->
