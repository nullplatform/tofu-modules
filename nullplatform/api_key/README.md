# Module: api_key

## Description

Creates and manages Nullplatform API keys with pre-configured or custom role grants and tags

## Features

- Creates Nullplatform API keys with configurable access grants
- Supports multiple pre-configured API key types with role-based access
- Generates agent keys with developer, ops, secops, and secrets-reader roles
- Configures scope and service notification channel keys with appropriate permissions
- Enables custom API key creation with user-defined names, roles, and tags
- Automatically applies NRN-based tags for organization, account, and namespace
- Manages API key lifecycle with create-before-destroy strategy

## Basic Usage

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.36.0"

  nrn  = "your-nrn"
  type = "your-type"
}
```

### Usage with Agent API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.36.0"

  nrn  = "your-nrn"
  type = "agent"
}
```

### Usage with Scope Notification API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.36.0"

  nrn  = "your-nrn"
  type = "scope_notification"
}
```

### Usage with Service Notification API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.36.0"

  nrn  = "your-nrn"
  type = "service_notification"
}
```

### Usage with Custom API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.36.0"

  custom_name       = "your-custom-name"  # Required when type = "custom"
  custom_role_slugs = "your-custom-role-slugs"  # Required when type = "custom"
  nrn               = "your-nrn"
  type              = "custom"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.api_key.api_key
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.76 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.76 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_api_key.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/api_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Name for the API key (required when type is 'custom') | `string` | `null` | no |
| <a name="input_custom_role_slugs"></a> [custom\_role\_slugs](#input\_custom\_role\_slugs) | List of role slugs to assign (required when type is 'custom', must have at least 1) | `list(string)` | `[]` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Additional tags to apply to the API key (optional, only used when type is 'custom') | <pre>list(object({<br/>    key   = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789) | `string` | n/a | yes |
| <a name="input_specification_slug"></a> [specification\_slug](#input\_specification\_slug) | Specification slug used for the usedBy tag (required for scope\_notification and service\_notification types) | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of API key to create. Determines the pre-configured grants and tags. Use 'custom' to define your own roles and tags. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_key"></a> [api\_key](#output\_api\_key) | The generated API key value |
| <a name="output_id"></a> [id](#output\_id) | The ID of the API key resource |
| <a name="output_name"></a> [name](#output\_name) | The name of the API key |
<!-- END_TF_DOCS -->
