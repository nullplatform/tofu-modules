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
<!-- END_TF_DOCS -->
