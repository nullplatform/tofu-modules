# Module: Agent API Key

Creates a nullplatform API key pre-configured for the **agent** role. Grants and tags are hardcoded — only the NRN is required.

### Grants

- `controlplane:agent`
- `developer`
- `ops`
- `secops`
- `secrets-reader`

### Tags

- `managedBy = IaC`
- NRN-derived tags (organization, account, namespace)

## Usage

```hcl
module "agent_api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent_api_key?ref=v1.0.0"
  nrn    = var.nrn
}

module "agent" {
  source     = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v1.0.0"
  api_key    = module.agent_api_key.api_key
  nrn        = var.nrn
  # ...
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
