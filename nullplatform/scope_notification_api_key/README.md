# Module: Scope Notification API Key

Creates a nullplatform API key pre-configured for **scope notification channels**. Grants and tags are hardcoded — only the NRN is required.

### Grants

- `controlplane:agent`
- `ops`

### Tags

- `managedBy = IaC`
- `usedBy = K8S`
- NRN-derived tags (organization, account, namespace)

## Usage

```hcl
module "scope_notification_api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_notification_api_key?ref=v1.0.0"
  nrn    = var.nrn
}

module "scope_definition_agent_association" {
  source                   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition_agent_association?ref=v1.0.0"
  api_key                  = module.scope_notification_api_key.api_key
  nrn                      = var.nrn
  scope_specification_id   = module.scope_definition.service_specification_id
  scope_specification_slug = module.scope_definition.service_slug
  tags_selectors           = var.tags_selectors

  depends_on = [module.agent]
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
