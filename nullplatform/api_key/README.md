# Module: api_key

## Description

Creates a Nullplatform API key with configurable grants and tags based on predefined types or custom configurations

## Architecture

The module creates a nullplatform_api_key resource with dynamically generated grants and tags. For predefined types (agent, scope_notification, service_notification), it extracts NRN components (organization, account, namespace) from the input NRN string and maps them to role slugs defined in local configurations. For custom type, it accepts either custom_role_slugs paired with a module-level NRN or custom_grants with per-grant NRN definitions. Tags are automatically generated from NRN components and merged with custom tags. Lifecycle preconditions enforce validation rules ensuring required variables are provided based on the selected type.

## Features

- Creates nullplatform_api_key resource with configurable grants based on role slugs
- Generates automatic tags from NRN components (organization, account, namespace)
- Supports predefined API key types with pre-configured role mappings for agents and notifications
- Enables custom API key configuration with user-defined role slugs and grants
- Allows per-grant NRN specification for multi-resource access patterns
- Validates required fields using lifecycle preconditions based on selected type
- Outputs sensitive API key value along with resource ID and name

## Basic Usage

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.54.0"

  type = "your-type"
}
```

### Usage with Agent API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.54.0"

  nrn  = "your-nrn"  # Required when type = "agent"
  type = "agent"
}
```

### Usage with Scope Notification API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.54.0"

  nrn                = "your-nrn"  # Required when type = "scope_notification"
  specification_slug = "your-specification-slug"  # Required when type = "scope_notification"
  type               = "scope_notification"
}
```

### Usage with Service Notification API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.54.0"

  nrn                = "your-nrn"  # Required when type = "service_notification"
  specification_slug = "your-specification-slug"  # Required when type = "service_notification"
  type               = "service_notification"
}
```

### Usage with Custom API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.54.0"

  custom_name = "your-custom-name"  # Required when type = "custom"
  type        = "custom"
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
| <a name="input_custom_grants"></a> [custom\_grants](#input\_custom\_grants) | List of grants with explicit NRN and role\_slug pairs. Allows assigning different NRNs per grant (used when type is 'custom'). | <pre>list(object({<br/>    nrn       = string<br/>    role_slug = string<br/>  }))</pre> | `[]` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Name for the API key (required when type is 'custom') | `string` | `null` | no |
| <a name="input_custom_role_slugs"></a> [custom\_role\_slugs](#input\_custom\_role\_slugs) | List of role slugs to assign using the module-level NRN (used when type is 'custom' and custom\_grants is empty) | `list(string)` | `[]` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Additional tags to apply to the API key (optional, only used when type is 'custom') | <pre>list(object({<br/>    key   = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789). Required for predefined types (agent, scope\_notification, service\_notification). Optional for custom type when using custom\_grants. | `string` | `null` | no |
| <a name="input_specification_slug"></a> [specification\_slug](#input\_specification\_slug) | Specification slug used for the usedBy tag (required for scope\_notification and service\_notification types) | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of API key to create. Determines the pre-configured grants and tags. Use 'custom' to define your own roles and tags. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_key"></a> [api\_key](#output\_api\_key) | The generated API key value |
| <a name="output_id"></a> [id](#output\_id) | The ID of the API key resource |
| <a name="output_name"></a> [name](#output\_name) | The name of the API key |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "api_key",
  "description": "Creates a Nullplatform API key with configurable grants and tags based on predefined types or custom configurations",
  "architecture": "The module creates a nullplatform_api_key resource with dynamically generated grants and tags. For predefined types (agent, scope_notification, service_notification), it extracts NRN components (organization, account, namespace) from the input NRN string and maps them to role slugs defined in local configurations. For custom type, it accepts either custom_role_slugs paired with a module-level NRN or custom_grants with per-grant NRN definitions. Tags are automatically generated from NRN components and merged with custom tags. Lifecycle preconditions enforce validation rules ensuring required variables are provided based on the selected type.",
  "features": [
    "Creates nullplatform_api_key resource with configurable grants based on role slugs",
    "Generates automatic tags from NRN components (organization, account, namespace)",
    "Supports predefined API key types with pre-configured role mappings for agents and notifications",
    "Enables custom API key configuration with user-defined role slugs and grants",
    "Allows per-grant NRN specification for multi-resource access patterns",
    "Validates required fields using lifecycle preconditions based on selected type",
    "Outputs sensitive API key value along with resource ID and name"
  ],
  "inputs": [
    {
      "name": "type",
      "description": "Type of API key to create. Determines the pre-configured grants and tags. Use 'custom' to define your own roles and tags.",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789). Required for predefined types (agent, scope_notification, service_notification). Optional for custom type when using custom_grants.",
      "required": false
    },
    {
      "name": "specification_slug",
      "description": "Specification slug used for the usedBy tag (required for scope_notification and service_notification types)",
      "required": false
    },
    {
      "name": "custom_name",
      "description": "Name for the API key (required when type is 'custom')",
      "required": false
    },
    {
      "name": "custom_role_slugs",
      "description": "List of role slugs to assign using the module-level NRN (used when type is 'custom' and custom_grants is empty)",
      "required": false
    },
    {
      "name": "custom_grants",
      "description": "List of grants with explicit NRN and role_slug pairs. Allows assigning different NRNs per grant (used when type is 'custom').",
      "required": false
    },
    {
      "name": "custom_tags",
      "description": "Additional tags to apply to the API key (optional, only used when type is 'custom')",
      "required": false
    }
  ],
  "outputs": [
    "api_key",
    "id",
    "name"
  ],
  "hash": "ffaaca797785e4d60e00662b7a70c089"
}
END_AI_METADATA -->
