# Module: cloud

## Description

Configures Oracle Cloud Infrastructure (OCI) provider settings in Nullplatform with account, compartment, and networking configuration

## Features

- Creates Nullplatform provider configuration for OCI integration
- Configures OCI account and tenancy details including region
- Manages compartment settings for resource organization
- Supports custom domain name configuration for networking
- Enables application domain and private domain name settings
- Supports flexible dimensions for provider configuration customization
- Implements lifecycle management to ignore authentication attribute changes

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/oci/cloud?ref=v1.42.0"

  account_id       = var.account_id
  account_name     = var.account_name
  account_region   = var.region
  compartment_id   = var.compartment_id
  compartment_name = var.compartment_name
  domain_name      = local.domain_name
  nrn              = var.nrn
}
```

## Using Outputs

```hcl
# This module registers the OCI cloud provider in Nullplatform.
# No downstream Terraform consumers — configuration is applied via the Nullplatform API.
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
| [nullplatform_provider_config.oci](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | OCI tenancy/account OCID | `string` | n/a | yes |
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | OCI account/tenancy name | `string` | n/a | yes |
| <a name="input_account_region"></a> [account\_region](#input\_account\_region) | OCI region where resources will be deployed | `string` | n/a | yes |
| <a name="input_application_domain"></a> [application\_domain](#input\_application\_domain) | Whether to apply application domain | `bool` | `false` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCI compartment OCID where resources will be created | `string` | n/a | yes |
| <a name="input_compartment_name"></a> [compartment\_name](#input\_compartment\_name) | OCI compartment name | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the configuration | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | Private domain name | `string` | `""` | no |
<!-- END_TF_DOCS -->
