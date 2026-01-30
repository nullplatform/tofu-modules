# Module: Service Notification API Key

Creates a nullplatform API key pre-configured for **service notification channels**. Grants and tags are hardcoded — only the NRN is required.

### Grants

- `controlplane:agent`
- `admin`
- `ops`

### Tags

- `managedBy = IaC`
- `usedBy = POSTGRESQL`
- NRN-derived tags (organization, account, namespace)

## Usage

```hcl
module "service_notification_api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_notification_api_key?ref=v1.0.0"
  nrn    = var.nrn
}

module "service_definition_agent_association" {
  source                     = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_definition_agent_association?ref=v1.0.0"
  api_key                    = module.service_notification_api_key.api_key
  nrn                        = var.nrn
  tags_selectors             = var.tags_selectors
  service_specification_id   = "123"
  service_specification_slug = "PostgreSQL"
  service_path               = "databases/postgres"

  depends_on = [module.agent]
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
