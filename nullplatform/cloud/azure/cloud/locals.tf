locals {
  # `authentication` sent empty (no credentials set, meaning "inherit from a
  # parent cloud provider") is meaningless to the API and causes drift —
  # omit unless at least one credential is actually set.
  authentication = {
    for k, v in {
      client_id       = var.client_id
      client_secret   = var.client_secret
      subscription_id = var.subscription_id
      tenant_id       = var.tenant_id
    } : k => v if v != null
  }
}