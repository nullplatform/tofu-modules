locals {
  # `authentication` is optional in the "azure-configuration" schema (only
  # `networking` is required, and none of authentication's own sub-fields are
  # required either). Sending it as {} when unconfigured (all four
  # credentials null, meaning "inherit from a parent cloud provider") is
  # meaningless to the API, which never persists it back, causing perpetual
  # drift. Omit the whole key unless at least one credential is actually set.
  authentication = {
    for k, v in {
      client_id       = var.client_id
      client_secret   = var.client_secret
      subscription_id = var.subscription_id
      tenant_id       = var.tenant_id
    } : k => v if v != null
  }
}