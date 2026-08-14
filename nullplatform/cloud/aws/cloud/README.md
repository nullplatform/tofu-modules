# Module: cloud

## Description

Configures a nullplatform AWS provider by registering account identity, region, and DNS networking settings via a nullplatform_provider_config resource

## Architecture

The module uses data sources aws_caller_identity and aws_region to dynamically retrieve the current AWS account ID and region at apply time. These values, along with DNS variables, are merged into a structured attributes payload and passed to a nullplatform_provider_config resource of type aws-configuration. A local map conditionally includes hosted_public_zone_id in the networking block only when it is non-empty and non-null, preventing API rejection of empty strings. The nrn and dimensions variables control resource targeting and dimensional scoping within the nullplatform provider.

## Features

- Creates a nullplatform_provider_config resource that registers AWS account and region metadata with the nullplatform API
- Dynamically resolves AWS account ID and region using aws_caller_identity and aws_region data sources
- Conditionally includes the public Route53 hosted zone ID in the provider config payload to support private-only DNS installations
- Validates hosted_public_zone_id format against the Route53 zone ID pattern ^Z[A-Z0-9]{10,}$ while allowing empty or null values
- Supports configurable dimension maps for scoping nullplatform provider configurations across environments
- Configures private DNS networking with a required hosted_private_zone_id and optional public zone for hybrid DNS setups

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/cloud?ref=v6.16.1"

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
| <a name="input_application_domain"></a> [application\_domain](#input\_application\_domain) | Add account name in domain | `bool` | `false` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Map of dimension values to configure nullplatform | `map(string)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the configuration | `string` | n/a | yes |
| <a name="input_hosted_private_zone_id"></a> [hosted\_private\_zone\_id](#input\_hosted\_private\_zone\_id) | Hosted zone ID for private DNS | `string` | n/a | yes |
| <a name="input_hosted_public_zone_id"></a> [hosted\_public\_zone\_id](#input\_hosted\_public\_zone\_id) | Hosted zone ID for public DNS. Leave empty for private-only installs: when empty it is omitted from the provider config payload (the API rejects an empty string). | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloud",
  "description": "Configures a nullplatform AWS provider by registering account identity, region, and DNS networking settings via a nullplatform_provider_config resource",
  "architecture": "The module uses data sources aws_caller_identity and aws_region to dynamically retrieve the current AWS account ID and region at apply time. These values, along with DNS variables, are merged into a structured attributes payload and passed to a nullplatform_provider_config resource of type aws-configuration. A local map conditionally includes hosted_public_zone_id in the networking block only when it is non-empty and non-null, preventing API rejection of empty strings. The nrn and dimensions variables control resource targeting and dimensional scoping within the nullplatform provider.",
  "features": [
    "Creates a nullplatform_provider_config resource that registers AWS account and region metadata with the nullplatform API",
    "Dynamically resolves AWS account ID and region using aws_caller_identity and aws_region data sources",
    "Conditionally includes the public Route53 hosted zone ID in the provider config payload to support private-only DNS installations",
    "Validates hosted_public_zone_id format against the Route53 zone ID pattern ^Z[A-Z0-9]{10,}$ while allowing empty or null values",
    "Supports configurable dimension maps for scoping nullplatform provider configurations across environments",
    "Configures private DNS networking with a required hosted_private_zone_id and optional public zone for hybrid DNS setups"
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
  "hash": "da1b824db5bc97987c9007c20fd0f1e7"
}
END_AI_METADATA -->
