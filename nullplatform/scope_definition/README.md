
# Module: Scope Definition

This Terraform module clones a Git repository containing service and action specification templates, processes those templates using gomplate to inject dynamic variables, and then creates corresponding nullplatform resources (service, scope type, and actions). It also patches the target NRN with logging and metrics providers and cleans up the cloned repository after execution

Usage:

```
module "scope_definition" {
  source               = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/scope_definition?ref=v1.0.0"
  nrn                  = local.nrn_without_namespace
  np_api_key           = var.np_api_key
```


<!-- BEGIN_TF_DOCS -->


<!-- END_TF_DOCS -->

