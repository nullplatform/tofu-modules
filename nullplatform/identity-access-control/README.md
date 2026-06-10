# Module: identity-access-control

## Description

Configures an identity & access control provider in nullplatform via a `nullplatform_provider_config` resource. The provider type defaults to the AWS IAM provider (`aws-iam-configuration`) but is exposed as a variable, so new clouds can be supported by passing their own `type` and `attributes`.

## Architecture

The module creates a single `nullplatform_provider_config` resource. The `type` input selects which provider specification to configure (default `aws-iam-configuration`), and the `attributes` input carries the provider-specific configuration, JSON-encoded to match that specification's schema. `dimensions` metadata is supported for environment- or region-specific configuration. The module is intentionally generic: it does not validate cloud-specific attribute shapes, leaving that to the caller, so adding a new cloud requires no changes here. Unlike provider configs that hold externally-rotated secrets, this module does not set `ignore_changes` on `attributes`, so Terraform remains the source of truth and changes are propagated on apply.

For AWS, this module is the platform-side counterpart to `infrastructure/aws/iam/agent`: that module grants the agent `sts:AssumeRole` permission over the role ARNs, while this module publishes those ARNs to nullplatform under friendly selectors.

## Features

- Creates a nullplatform identity & access control provider configuration
- Cloud-agnostic: `type` and `attributes` are inputs, defaulting to AWS IAM
- For AWS IAM, maps friendly selectors to assumable IAM role ARNs for use in scope/service code
- Supports dimensions for environment- or region-specific configuration
- Keeps Terraform as the source of truth for the configuration (no attribute drift suppression)

## Basic Usage (AWS IAM — default)

```hcl
module "identity_access_control" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/identity-access-control?ref=v4.0.1"

  nrn = "your-nrn"

  attributes = {
    iam_role_arns = {
      arns = [
        {
          selector = "billing"
          arn      = "arn:aws:iam::123456789012:role/billing-reader"
        },
        {
          selector = "analytics"
          arn      = "arn:aws:iam::123456789012:role/analytics-reader"
        },
      ]
    }
  }
}
```

## Usage for a new cloud

```hcl
module "identity_access_control" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/identity-access-control?ref=v4.0.1"

  nrn  = "your-nrn"
  type = "azure-iam-configuration" # slug of the provider specification

  attributes = {
    # ... shape matching the azure-iam-configuration schema
  }
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.identity_access_control.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.86 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.identity_access_control](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nrn"></a> [nrn](#input\_nrn) | nullplatform Resource Name where the provider configuration applies | `string` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Provider-specific configuration, matching the schema of the selected provider type | `any` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Slug of the nullplatform provider specification to configure | `string` | `"aws-iam-configuration"` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions used to scope this provider configuration | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the provider configuration |
| <a name="output_nrn"></a> [nrn](#output\_nrn) | NRN the provider configuration is attached to |
<!-- END_TF_DOCS -->
