# Module: parameter_storage_configuration

## Description

Configures a nullplatform provider config resource for AWS parameter storage backends, supporting both AWS Secrets Manager and AWS Systems Manager Parameter Store

## Architecture

The module creates a single nullplatform_provider_config resource named parameter_store_configuration, wiring the nrn, type, and dimensions inputs directly into the resource. Type-specific attribute defaults are defined in local.type_defaults and merged with caller-supplied overrides in local.type_overrides, then serialized via jsonencode() into the resource's attributes field. The resolved provider_config_id is surfaced as an output for downstream consumption.

## Features

- Creates a nullplatform_provider_config resource anchored to a given NRN with type-aware attribute defaults
- Supports AWS Secrets Manager backend with secret-scoped sensibility defaults and optional customer-managed KMS key
- Supports AWS Systems Manager Parameter Store backend with non_secret sensibility and configurable SSM tier (Standard, Advanced, Intelligent-Tiering)
- Merges caller-supplied overrides on top of per-type defaults to prevent attribute drift
- Restricts applies_to values to valid entries (secret, non_secret) with non-empty list enforcement
- Accepts dimension map for environment-scoped or multi-tenant provider config targeting

## Basic Usage

```hcl
module "parameter_storage_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_configuration?ref=v7.3.1"

  nrn  = "your-nrn"
  type = "your-type"
}
```

### Usage with AWS Secrets Manager

```hcl
module "parameter_storage_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_configuration?ref=v7.3.1"

  nrn  = "your-nrn"
  type = "aws-secrets-manager"
}
```

### Usage with AWS Parameter Store

```hcl
module "parameter_storage_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_configuration?ref=v7.3.1"

  nrn  = "your-nrn"
  tier = "your-tier"  # Required when type = "aws-parameter-store"
  type = "aws-parameter-store"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.parameter_storage_configuration.provider_config_id
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
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.96 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.parameter_store_configuration](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_applies_to"></a> [applies\_to](#input\_applies\_to) | Which parameters this backend stores: any of secret, non\_secret. Defaults to the spec's own default for the type — ["secret"] for aws-secrets-manager, ["non\_secret"] for aws-parameter-store. | `list(string)` | `null` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimension values for this instance (e.g. { environment = "production" }). | `map(string)` | `{}` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Customer-managed KMS key ARN or alias. If empty, the service's AWS-managed key is used (aws/secretsmanager for aws-secrets-manager, alias/aws/ssm for aws-parameter-store). | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where this parameter-storage instance (provider config) is anchored. | `string` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | aws-parameter-store only. SSM parameter tier: Standard (free up to 10,000 parameters), Advanced (larger values, billed per parameter) or Intelligent-Tiering. Defaults to Standard. | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | Provider specification slug this configuration targets. Determines which default attribute shape is applied — see README for the supported types and their payloads. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_config_id"></a> [provider\_config\_id](#output\_provider\_config\_id) | ID of the created provider config (parameter-storage instance). |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "parameter_storage_configuration",
  "description": "Configures a nullplatform provider config resource for AWS parameter storage backends, supporting both AWS Secrets Manager and AWS Systems Manager Parameter Store",
  "architecture": "The module creates a single nullplatform_provider_config resource named parameter_store_configuration, wiring the nrn, type, and dimensions inputs directly into the resource. Type-specific attribute defaults are defined in local.type_defaults and merged with caller-supplied overrides in local.type_overrides, then serialized via jsonencode() into the resource's attributes field. The resolved provider_config_id is surfaced as an output for downstream consumption.",
  "features": [
    "Creates a nullplatform_provider_config resource anchored to a given NRN with type-aware attribute defaults",
    "Supports AWS Secrets Manager backend with secret-scoped sensibility defaults and optional customer-managed KMS key",
    "Supports AWS Systems Manager Parameter Store backend with non_secret sensibility and configurable SSM tier (Standard, Advanced, Intelligent-Tiering)",
    "Merges caller-supplied overrides on top of per-type defaults to prevent attribute drift",
    "Restricts applies_to values to valid entries (secret, non_secret) with non-empty list enforcement",
    "Accepts dimension map for environment-scoped or multi-tenant provider config targeting"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN where this parameter-storage instance (provider config) is anchored.",
      "required": true
    },
    {
      "name": "type",
      "description": "Provider specification slug this configuration targets. Determines which default attribute shape is applied — see README for the supported types and their payloads.",
      "required": true
    },
    {
      "name": "applies_to",
      "description": "Which parameters this backend stores: any of secret, non_secret. Defaults to the spec's own default for the type — [\\",
      "required": false
    },
    {
      "name": "tier",
      "description": "aws-parameter-store only. SSM parameter tier: Standard (free up to 10,000 parameters), Advanced (larger values, billed per parameter) or Intelligent-Tiering. Defaults to Standard.",
      "required": false
    },
    {
      "name": "kms_key_id",
      "description": "Customer-managed KMS key ARN or alias. If empty, the service's AWS-managed key is used (aws/secretsmanager for aws-secrets-manager, alias/aws/ssm for aws-parameter-store).",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Dimension values for this instance (e.g. { environment = \\",
      "required": false
    }
  ],
  "outputs": [
    "provider_config_id"
  ],
  "hash": "89bf33550a4e5fa808cad573cb6fdfa2"
}
END_AI_METADATA -->
