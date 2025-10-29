



# Module: Scope Definition agent association

This Terraform code creates a notification channel in nullplatform that links to a specific NRN and can dynamically configure an agent-based channel when needed.
It injects the agent’s API key, command configuration, and optional overrides, while preserving any filters defined in the original template.

Usage:

```
module "scope_definition_agent_association" {
    source                     = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/
    nrn                        = var.nrn
    np_api_key                 = var.np_api_key
    service_specification_id   = module.scope_definition.service_specification_id
    service_specification_slug = module.scope_definition.service_slug
    tags_selectors             = var.tags_selectors

}

```
<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->