# Module: api_key

## Description

Creates and configures a nullplatform API key resource with pre-defined or custom role grants and tags based on the specified key type

## Architecture

The module defines a single nullplatform_api_key resource whose name, grants, and tags are driven by a locals.tf configuration map keyed on var.type. For predefined types (agent, base, scope_notification, service_notification), role slugs from the config map are expanded into dynamic grants blocks using the provided NRN, while custom type reads directly from var.custom_role_slugs or var.custom_grants. Tags are merged from NRN-parsed key-value pairs, a static managedBy label, and optional custom_tags, then injected via a dynamic tags block. Lifecycle preconditions enforce type-specific invariants such as requiring custom_name and at least one role or grant for the custom type, and specification_slug for notification types.

## Features

- Creates a nullplatform_api_key resource with pre-configured role grants for agent, base, scope_notification, and service_notification types
- Generates role grants dynamically from a type-keyed configuration map mapping role slugs to NRN-scoped grant blocks
- Parses the NRN string into structured tags automatically applied to the API key alongside a managedBy IaC label
- Supports fully custom API keys with caller-defined name, role slugs, or explicit per-grant NRN and role_slug pairs
- Enforces type-specific preconditions via Terraform lifecycle blocks to catch misconfiguration at plan time
- Outputs the sensitive API key value, resource ID, and key name for downstream consumption

## Basic Usage

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v7.3.1"

  type = "your-type"
}
```

### Usage with Agent API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v7.3.1"

  nrn  = "your-nrn"  # Required when type = "agent"
  type = "agent"
}
```

### Usage with Base API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v7.3.1"

  nrn  = "your-nrn"  # Required when type = "base"
  type = "base"
}
```

### Usage with Scope Notification API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v7.3.1"

  nrn                = "your-nrn"  # Required when type = "scope_notification"
  specification_slug = "your-specification-slug"  # Required when type = "scope_notification"
  type               = "scope_notification"
}
```

### Usage with Service Notification API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v7.3.1"

  nrn                = "your-nrn"  # Required when type = "service_notification"
  specification_slug = "your-specification-slug"  # Required when type = "service_notification"
  type               = "service_notification"
}
```

### Usage with Custom API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v7.3.1"

  custom_name       = "your-custom-name"  # Required when type = "custom"
  custom_role_slugs = "your-custom-role-slugs"  # Required when type = "custom"
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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.101 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.101 |

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
| <a name="input_internal"></a> [internal](#input\_internal) | Marks the API key as internal to nullplatform, keeping it out of the API key listing (`GET /api_key` and the UI) while it stays readable by ID — for the plumbing credentials this module creates (agents, notification channels) rather than keys a person manages. Create-only in the API, so changing it replaces the key and rotates its secret. Leave unset for the platform default (not internal). | `bool` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789). Required for predefined types (agent, base, scope\_notification, service\_notification). Optional for custom type when using custom\_grants. | `string` | `null` | no |
| <a name="input_specification_slug"></a> [specification\_slug](#input\_specification\_slug) | Specification slug used for the usedBy tag (required for scope\_notification and service\_notification types) | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of API key to create. Determines the pre-configured grants and tags. 'base' carries the agent roles minus secrets-reader, for the nullplatform base module. Use 'custom' to define your own roles and tags. | `string` | n/a | yes |

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
  "description": "Creates and configures a nullplatform API key resource with pre-defined or custom role grants and tags based on the specified key type",
  "architecture": "The module defines a single nullplatform_api_key resource whose name, grants, and tags are driven by a locals.tf configuration map keyed on var.type. For predefined types (agent, base, scope_notification, service_notification), role slugs from the config map are expanded into dynamic grants blocks using the provided NRN, while custom type reads directly from var.custom_role_slugs or var.custom_grants. Tags are merged from NRN-parsed key-value pairs, a static managedBy label, and optional custom_tags, then injected via a dynamic tags block. Lifecycle preconditions enforce type-specific invariants such as requiring custom_name and at least one role or grant for the custom type, and specification_slug for notification types.",
  "features": [
    "Creates a nullplatform_api_key resource with pre-configured role grants for agent, base, scope_notification, and service_notification types",
    "Generates role grants dynamically from a type-keyed configuration map mapping role slugs to NRN-scoped grant blocks",
    "Parses the NRN string into structured tags automatically applied to the API key alongside a managedBy IaC label",
    "Supports fully custom API keys with caller-defined name, role slugs, or explicit per-grant NRN and role_slug pairs",
    "Enforces type-specific preconditions via Terraform lifecycle blocks to catch misconfiguration at plan time",
    "Outputs the sensitive API key value, resource ID, and key name for downstream consumption"
  ],
  "inputs": [
    {
      "name": "type",
      "description": "Type of API key to create. Determines the pre-configured grants and tags. 'base' carries the agent roles minus secrets-reader, for the nullplatform base module. Use 'custom' to define your own roles and tags.",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789). Required for predefined types (agent, base, scope_notification, service_notification). Optional for custom type when using custom_grants.",
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
    },
    {
      "name": "internal",
      "description": "Marks the API key as internal to nullplatform, keeping it out of the API key listing (`GET /api_key` and the UI) while it stays readable by ID — for the plumbing credentials this module creates (agents, notification channels) rather than keys a person manages. Create-only in the API, so changing it replaces the key and rotates its secret. Leave unset for the platform default (not internal).",
      "required": false
    }
  ],
  "outputs": [
    "api_key",
    "id",
    "name"
  ],
  "hash": "dd7eace1ca72252a660bc55a53b16d3a"
}
END_AI_METADATA -->
