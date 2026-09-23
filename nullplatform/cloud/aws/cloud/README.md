# Module: cloud

## Description

Registers an AWS provider configuration with Nullplatform by assembling account identity and networking attributes into a nullplatform_provider_config resource

## Architecture

The module conditionally fetches the AWS account ID via aws_caller_identity and the region via aws_region data sources when those values are not explicitly provided. Local values merge the resolved account identity with networking configuration, conditionally including hosted_public_zone_id only when non-empty to support private-only DNS setups. A single nullplatform_provider_config resource of type aws-configuration is created, receiving the assembled account and networking attributes as a JSON-encoded payload along with the NRN identifier and optional dimension map.

## Features

- Creates a nullplatform_provider_config resource of type aws-configuration with JSON-encoded AWS account and networking attributes
- Resolves AWS account ID automatically from aws_caller_identity when not explicitly provided
- Resolves AWS region automatically from aws_region data source when not explicitly provided
- Conditionally omits hosted_public_zone_id from the networking payload to support private-only DNS installations
- Validates Route53 hosted zone ID format using regex pattern ^Z[A-Z0-9]{10,}$ for both public and private zone IDs
- Supports optional dimension map for multi-dimensional Nullplatform provider scoping
- Supports optional application domain flag to include account name in domain configuration

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/cloud?ref=v8.0.0"

  domain_name            = "your-domain-name"
  hosted_private_zone_id = "your-hosted-private-zone-id"
  nrn                    = "your-nrn"
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.43.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.aws](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID to register. Asserted by the caller and only format-checked, not verified against any AWS credentials. Leave unset to read it from the AWS provider credentials (aws\_caller\_identity). | `string` | `null` | no |
| <a name="input_application_domain"></a> [application\_domain](#input\_application\_domain) | Add account name in domain | `bool` | `false` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Map of dimension values to configure nullplatform | `map(string)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the configuration | `string` | n/a | yes |
| <a name="input_hosted_private_zone_id"></a> [hosted\_private\_zone\_id](#input\_hosted\_private\_zone\_id) | Hosted zone ID for private DNS | `string` | n/a | yes |
| <a name="input_hosted_public_zone_id"></a> [hosted\_public\_zone\_id](#input\_hosted\_public\_zone\_id) | Hosted zone ID for public DNS. Leave empty for private-only installs: when empty it is omitted from the provider config payload (the API rejects an empty string). | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region to register. Asserted by the caller and only format-checked, not verified against the AWS provider. Leave unset to read it from the AWS provider configuration (aws\_region). | `string` | `null` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloud",
  "description": "Registers an AWS provider configuration with Nullplatform by assembling account identity and networking attributes into a nullplatform_provider_config resource",
  "architecture": "The module conditionally fetches the AWS account ID via aws_caller_identity and the region via aws_region data sources when those values are not explicitly provided. Local values merge the resolved account identity with networking configuration, conditionally including hosted_public_zone_id only when non-empty to support private-only DNS setups. A single nullplatform_provider_config resource of type aws-configuration is created, receiving the assembled account and networking attributes as a JSON-encoded payload along with the NRN identifier and optional dimension map.",
  "features": [
    "Creates a nullplatform_provider_config resource of type aws-configuration with JSON-encoded AWS account and networking attributes",
    "Resolves AWS account ID automatically from aws_caller_identity when not explicitly provided",
    "Resolves AWS region automatically from aws_region data source when not explicitly provided",
    "Conditionally omits hosted_public_zone_id from the networking payload to support private-only DNS installations",
    "Validates Route53 hosted zone ID format using regex pattern ^Z[A-Z0-9]{10,}$ for both public and private zone IDs",
    "Supports optional dimension map for multi-dimensional Nullplatform provider scoping",
    "Supports optional application domain flag to include account name in domain configuration"
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
      "name": "hosted_private_zone_id",
      "description": "Hosted zone ID for private DNS",
      "required": true
    },
    {
      "name": "hosted_public_zone_id",
      "description": "Hosted zone ID for public DNS. Leave empty for private-only installs: when empty it is omitted from the provider config payload (the API rejects an empty string).",
      "required": false
    },
    {
      "name": "account_id",
      "description": "AWS account ID to register. Asserted by the caller and only format-checked, not verified against any AWS credentials. Leave unset to read it from the AWS provider credentials (aws_caller_identity).",
      "required": false
    },
    {
      "name": "region",
      "description": "AWS region to register. Asserted by the caller and only format-checked, not verified against the AWS provider. Leave unset to read it from the AWS provider configuration (aws_region).",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Map of dimension values to configure nullplatform",
      "required": false
    },
    {
      "name": "application_domain",
      "description": "Add account name in domain",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "c93a4cb28c32766f71b88d8f07b316a4"
}
END_AI_METADATA -->
