# Module: api_key

## Description

Creates and configures a nullplatform API key resource with pre-configured role grants and tags for agent, base, or custom use cases

## Architecture

The module instantiates a single nullplatform_api_key resource whose name, grants, and tags are derived from a locals.tf configuration map keyed by the type variable. For predefined types (agent, base), role slugs are resolved against a Nullplatform Resource Name (NRN) to produce grant blocks; for the custom type, grants are supplied directly or built from custom_role_slugs. Tags are merged from NRN-parsed components, a static managedBy label, and any caller-supplied custom_tags. Lifecycle preconditions enforce invariants such as requiring custom_name and at least one role source when type is custom.

## Features

- Creates nullplatform_api_key with pre-configured role grants for agent type including controlplane:agent, developer, ops, secops, and secrets-reader roles
- Creates nullplatform_api_key with base type grants identical to agent but excluding secrets-reader for nullplatform base module deployments
- Creates nullplatform_api_key with fully user-defined name, role slugs, and per-grant NRN overrides for custom type
- Merges NRN-derived organization, account, and namespace tags automatically onto the API key resource
- Supports internal flag to hide agent credentials from the API key listing UI while keeping them accessible by ID
- Enforces lifecycle preconditions to prevent misconfiguration such as mixing custom_grants with nrn or custom_role_slugs simultaneously

## Basic Usage

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v9.8.0"

  type = "your-type"
}
```

### Usage with Agent API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v9.8.0"

  nrn  = "your-nrn"  # Required when type = "agent"
  type = "agent"
}
```

### Usage with Base API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v9.8.0"

  nrn  = "your-nrn"  # Required when type = "base"
  type = "base"
}
```

### Usage with Custom API Key

```hcl
module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v9.8.0"

  custom_grants     = "your-custom-grants"  # Required when type = "custom"
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
| <a name="input_internal"></a> [internal](#input\_internal) | Marks the API key as internal to nullplatform, keeping it out of the API key listing (`GET /api_key` and the UI) while it stays readable by ID — for the plumbing credentials this module creates (agents) rather than keys a person manages. Create-only in the API, so changing it replaces the key and rotates its secret. Leave unset for the platform default (not internal). | `bool` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789). Required for predefined types (agent, base). Optional for custom type when using custom\_grants. | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of API key to create. Determines the pre-configured grants and tags. 'base' carries the agent roles minus secrets-reader, for the nullplatform base module. Use 'custom' to define your own roles and tags. Notification channel keys are no longer created here: the agent association modules let nullplatform create and manage the channel credential. | `string` | n/a | yes |

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
  "description": "Creates and configures a nullplatform API key resource with pre-configured role grants and tags for agent, base, or custom use cases",
  "architecture": "The module instantiates a single nullplatform_api_key resource whose name, grants, and tags are derived from a locals.tf configuration map keyed by the type variable. For predefined types (agent, base), role slugs are resolved against a Nullplatform Resource Name (NRN) to produce grant blocks; for the custom type, grants are supplied directly or built from custom_role_slugs. Tags are merged from NRN-parsed components, a static managedBy label, and any caller-supplied custom_tags. Lifecycle preconditions enforce invariants such as requiring custom_name and at least one role source when type is custom.",
  "features": [
    "Creates nullplatform_api_key with pre-configured role grants for agent type including controlplane:agent, developer, ops, secops, and secrets-reader roles",
    "Creates nullplatform_api_key with base type grants identical to agent but excluding secrets-reader for nullplatform base module deployments",
    "Creates nullplatform_api_key with fully user-defined name, role slugs, and per-grant NRN overrides for custom type",
    "Merges NRN-derived organization, account, and namespace tags automatically onto the API key resource",
    "Supports internal flag to hide agent credentials from the API key listing UI while keeping them accessible by ID",
    "Enforces lifecycle preconditions to prevent misconfiguration such as mixing custom_grants with nrn or custom_role_slugs simultaneously"
  ],
  "inputs": [
    {
      "name": "type",
      "description": "Type of API key to create. Determines the pre-configured grants and tags. 'base' carries the agent roles minus secrets-reader, for the nullplatform base module. Use 'custom' to define your own roles and tags. Notification channel keys are no longer created here: the agent association modules let nullplatform create and manage the channel credential.",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (e.g., organization=123:account=456:namespace=789). Required for predefined types (agent, base). Optional for custom type when using custom_grants.",
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
      "description": "Marks the API key as internal to nullplatform, keeping it out of the API key listing (`GET /api_key` and the UI) while it stays readable by ID — for the plumbing credentials this module creates (agents) rather than keys a person manages. Create-only in the API, so changing it replaces the key and rotates its secret. Leave unset for the platform default (not internal).",
      "required": false
    }
  ],
  "outputs": [
    "api_key",
    "id",
    "name"
  ],
  "hash": "3d34fda0ea8cb6631ae731b9ce68017c"
}
END_AI_METADATA -->
