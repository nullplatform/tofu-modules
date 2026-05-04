# Module: cloud

## Description

Configures Nullplatform provider with AWS account, region, and networking settings including domain and hosted zone information

## Architecture

The module creates a nullplatform_provider_config resource that aggregates AWS account information from data.aws_caller_identity and data.aws_region data sources. It constructs a JSON configuration containing IAM, account, and networking attributes, combining the AWS metadata with user-provided domain and hosted zone IDs. The configuration supports custom dimensions and includes lifecycle management to ignore attribute changes after creation.

## Features

- Creates Nullplatform provider configuration resource with AWS integration
- Retrieves current AWS account ID and region dynamically via data sources
- Configures networking attributes with domain name and Route53 hosted zone IDs
- Supports custom dimensions mapping for flexible provider configuration
- Implements lifecycle ignore_changes for attributes to prevent drift detection
- Enables application domain prefix based on account name configuration

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/cloud?ref=v2.0.2"

  domain_name            = "your-domain-name"
  hosted_private_zone_id = "your-hosted-private-zone-id"
  hosted_public_zone_id  = "your-hosted-public-zone-id"
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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.aws](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_domain"></a> [application\_domain](#input\_application\_domain) | Add account name in domain | `bool` | `false` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Map of dimension values to configure nullplatform | `map(string)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the configuration | `string` | n/a | yes |
| <a name="input_hosted_private_zone_id"></a> [hosted\_private\_zone\_id](#input\_hosted\_private\_zone\_id) | Hosted zone ID for private DNS | `string` | n/a | yes |
| <a name="input_hosted_public_zone_id"></a> [hosted\_public\_zone\_id](#input\_hosted\_public\_zone\_id) | Hosted zone ID for public DNS | `string` | n/a | yes |
| <a name="input_include_environment"></a> [include\_environment](#input\_include\_environment) | Whether to use Environment as a default dimension | `bool` | `true` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_scope_manager_assume_role"></a> [scope\_manager\_assume\_role](#input\_scope\_manager\_assume\_role) | ARN of the IAM role for scope and deploy manager | `string` | `"arn:aws:iam::283477532906:role/scope_and_deploy_manager"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloud",
  "description": "Configures Nullplatform provider with AWS account, region, and networking settings including domain and hosted zone information",
  "architecture": "The module creates a nullplatform_provider_config resource that aggregates AWS account information from data.aws_caller_identity and data.aws_region data sources. It constructs a JSON configuration containing IAM, account, and networking attributes, combining the AWS metadata with user-provided domain and hosted zone IDs. The configuration supports custom dimensions and includes lifecycle management to ignore attribute changes after creation.",
  "features": [
    "Creates Nullplatform provider configuration resource with AWS integration",
    "Retrieves current AWS account ID and region dynamically via data sources",
    "Configures networking attributes with domain name and Route53 hosted zone IDs",
    "Supports custom dimensions mapping for flexible provider configuration",
    "Implements lifecycle ignore_changes for attributes to prevent drift detection",
    "Enables application domain prefix based on account name configuration"
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
      "description": "Hosted zone ID for public DNS",
      "required": true
    },
    {
      "name": "scope_manager_assume_role",
      "description": "ARN of the IAM role for scope and deploy manager",
      "required": false
    },
    {
      "name": "include_environment",
      "description": "Whether to use Environment as a default dimension",
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
  "hash": "caad485091b4028f5be2077f631523db"
}
END_AI_METADATA -->
