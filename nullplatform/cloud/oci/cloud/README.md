# Module: cloud

## Description

Creates a Nullplatform provider configuration for Oracle Cloud Infrastructure (OCI) with account, compartment, and networking details

## Architecture

The module creates a single nullplatform_provider_config resource of type 'oci-configuration'. It passes the NRN identifier and dimensions map directly to the resource. The OCI account details (id, region, name), compartment information (id, name), and networking configuration (domain_name, application_domain, private_domain_name) are encoded as JSON attributes. The lifecycle block ensures these attributes are ignored after initial creation.

## Features

- Configures OCI provider settings for Nullplatform integration
- Supports custom dimensions for provider configuration
- Manages networking domain settings including private domains
- Ignores attribute changes after initial creation

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/oci/cloud?ref=v6.3.0"

  account_id       = "your-account-id"
  account_name     = "your-account-name"
  account_region   = "your-account-region"
  compartment_id   = "your-compartment-id"
  compartment_name = "your-compartment-name"
  domain_name      = "your-domain-name"
  nrn              = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.cloud.id
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

<!-- BEGIN_AI_METADATA
{
  "name": "cloud",
  "description": "Creates a Nullplatform provider configuration for Oracle Cloud Infrastructure (OCI) with account, compartment, and networking details",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'oci-configuration'. It passes the NRN identifier and dimensions map directly to the resource. The OCI account details (id, region, name), compartment information (id, name), and networking configuration (domain_name, application_domain, private_domain_name) are encoded as JSON attributes. The lifecycle block ensures these attributes are ignored after initial creation.",
  "features": [
    "Configures OCI provider settings for Nullplatform integration",
    "Supports custom dimensions for provider configuration",
    "Manages networking domain settings including private domains",
    "Ignores attribute changes after initial creation"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Identifier Nullplatform Resources Name",
      "required": true
    },
    {
      "name": "account_id",
      "description": "OCI tenancy/account OCID",
      "required": true
    },
    {
      "name": "account_name",
      "description": "OCI account/tenancy name",
      "required": true
    },
    {
      "name": "account_region",
      "description": "OCI region where resources will be deployed",
      "required": true
    },
    {
      "name": "compartment_id",
      "description": "OCI compartment OCID where resources will be created",
      "required": true
    },
    {
      "name": "compartment_name",
      "description": "OCI compartment name",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "Domain name for the configuration",
      "required": true
    },
    {
      "name": "dimensions",
      "description": "Dimensions for the provider configuration",
      "required": false
    },
    {
      "name": "application_domain",
      "description": "Whether to apply application domain",
      "required": false
    },
    {
      "name": "private_domain_name",
      "description": "Private domain name",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "dac717dbe17fc2aafba2e42361d71690"
}
END_AI_METADATA -->
