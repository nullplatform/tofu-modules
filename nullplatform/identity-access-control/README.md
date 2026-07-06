# Module: identity-access-control

## Description

Configures a nullplatform identity and access control provider by creating a nullplatform_provider_config resource scoped to a given NRN with provider-specific attributes

## Architecture

The module creates a single nullplatform_provider_config resource named identity_access_control, wiring the input nrn directly to the resource's nrn field and encoding the attributes variable as JSON via jsonencode(). The type field defaults to aws-iam-configuration and the dimensions map is passed through to scope the configuration. Outputs expose the resource's id and nrn for downstream consumption.

## Features

- Creates a nullplatform_provider_config resource scoped to a specified NRN for identity and access control
- Encodes provider-specific attributes to JSON automatically using jsonencode() for compatibility with the nullplatform provider
- Supports configurable provider type slug to allow different cloud provider integrations beyond the default aws-iam-configuration
- Accepts dimension scoping via a map to target specific environments or regions
- Exposes the provider configuration ID and NRN as outputs for use by dependent modules

## Basic Usage

```hcl
module "identity-access-control" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/identity-access-control?ref=v6.1.0"

  attributes = "your-attributes"
  nrn        = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.identity-access-control.id
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
| [nullplatform_provider_config.identity_access_control](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Provider-specific configuration, matching the schema of the selected provider type. Encoded to JSON for the provider config. For aws-iam-configuration: { iam\_role\_arns = { arns = [{ selector, arn }] } }. | `any` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions used to scope this provider configuration (e.g., environment, region) | `map(string)` | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | nullplatform Resource Name where the identity & access control provider configuration applies | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Slug of the nullplatform provider specification to configure (e.g. aws-iam-configuration). Set this when adding support for a new cloud. | `string` | `"aws-iam-configuration"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the provider configuration |
| <a name="output_nrn"></a> [nrn](#output\_nrn) | NRN the provider configuration is attached to |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "identity-access-control",
  "description": "Configures a nullplatform identity and access control provider by creating a nullplatform_provider_config resource scoped to a given NRN with provider-specific attributes",
  "architecture": "The module creates a single nullplatform_provider_config resource named identity_access_control, wiring the input nrn directly to the resource's nrn field and encoding the attributes variable as JSON via jsonencode(). The type field defaults to aws-iam-configuration and the dimensions map is passed through to scope the configuration. Outputs expose the resource's id and nrn for downstream consumption.",
  "features": [
    "Creates a nullplatform_provider_config resource scoped to a specified NRN for identity and access control",
    "Encodes provider-specific attributes to JSON automatically using jsonencode() for compatibility with the nullplatform provider",
    "Supports configurable provider type slug to allow different cloud provider integrations beyond the default aws-iam-configuration",
    "Accepts dimension scoping via a map to target specific environments or regions",
    "Exposes the provider configuration ID and NRN as outputs for use by dependent modules"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "nullplatform Resource Name where the identity & access control provider configuration applies",
      "required": true
    },
    {
      "name": "attributes",
      "description": "Provider-specific configuration, matching the schema of the selected provider type. Encoded to JSON for the provider config. For aws-iam-configuration: { iam_role_arns = { arns = [{ selector, arn }] } }.",
      "required": true
    },
    {
      "name": "type",
      "description": "Slug of the nullplatform provider specification to configure (e.g. aws-iam-configuration). Set this when adding support for a new cloud.",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Dimensions used to scope this provider configuration (e.g., environment, region)",
      "required": false
    }
  ],
  "outputs": [
    "id",
    "nrn"
  ],
  "hash": "5f1135e770dc3ba32b95dde2b65f4f19"
}
END_AI_METADATA -->
