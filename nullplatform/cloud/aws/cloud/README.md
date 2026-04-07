# Module: cloud

## Description

Configures Nullplatform provider with AWS account details, networking configuration, and Route53 hosted zone information

## Architecture

The module creates a nullplatform_provider_config resource that stores AWS configuration as JSON-encoded attributes. It uses data.aws_caller_identity and data.aws_region to fetch current AWS account ID and region, then combines these with user-provided Route53 hosted zone IDs and domain names. The configuration flows into the nullplatform_provider_config resource which stores networking (domain name, hosted zone IDs, application domain flag) and account information (ID, region) as structured attributes.

## Features

- Creates Nullplatform provider configuration with AWS account integration
- Configures networking settings with Route53 private and public hosted zone IDs
- Automatically retrieves current AWS account ID and region using data sources
- Supports custom domain configuration with optional application domain prefix
- Manages provider configuration with lifecycle ignore_changes for attributes stability

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/cloud?ref=v1.52.0"

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
  "description": "Configures Nullplatform provider with AWS account details, networking configuration, and Route53 hosted zone information",
  "architecture": "The module creates a nullplatform_provider_config resource that stores AWS configuration as JSON-encoded attributes. It uses data.aws_caller_identity and data.aws_region to fetch current AWS account ID and region, then combines these with user-provided Route53 hosted zone IDs and domain names. The configuration flows into the nullplatform_provider_config resource which stores networking (domain name, hosted zone IDs, application domain flag) and account information (ID, region) as structured attributes.",
  "features": [
    "Creates Nullplatform provider configuration with AWS account integration",
    "Configures networking settings with Route53 private and public hosted zone IDs",
    "Automatically retrieves current AWS account ID and region using data sources",
    "Supports custom domain configuration with optional application domain prefix",
    "Manages provider configuration with lifecycle ignore_changes for attributes stability"
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
  "hash": "62d0fe22f50b046efadd187404878c41"
}
END_AI_METADATA -->
