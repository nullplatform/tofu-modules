# Module: API Key

Creates a nullplatform API key with pre-configured grants and tags based on the specified `type`.

## Supported types

| Type | Name Pattern | Grants |
|------|-------------|--------|
| `agent` | AGENT | controlplane:agent, developer, ops, secops, secrets-reader |
| `scope_notification` | SCOPE-NOTIFICATION-CHANNEL-{SLUG} | controlplane:agent, ops |
| `service_notification` | SERVICE-NOTIFICATION-CHANNEL-{SLUG} | controlplane:agent, admin, ops |

All types include `managedBy=IaC` and NRN-derived tags (organization, account, namespace).
For `scope_notification` and `service_notification`, a `usedBy={SLUG}` tag is added from `specification_slug`.

## Usage

```hcl
module "agent_api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.0.0"
  type   = "agent"
  nrn    = var.nrn
}

module "scope_notification_api_key" {
  source             = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.0.0"
  type               = "scope_notification"
  nrn                = var.nrn
  specification_slug = "k8s"
}

module "service_notification_api_key" {
  source             = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.0.0"
  type               = "service_notification"
  nrn                = var.nrn
  specification_slug = "PostgreSQL"
}

module "agent" {
  source  = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v1.0.0"
  api_key = module.agent_api_key.api_key
  nrn     = var.nrn
  # ...
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
