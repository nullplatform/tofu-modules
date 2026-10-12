################################################################################
# Push-only credential for CI
#
# A repository-scoped ACR token bound to the registry's built-in
# "_repositories_push" scope map: it can push and pull every repository, but
# cannot delete images or manage the registry the way the admin user can. Its
# username/password feed the nullplatform docker-server asset (CI build
# workflow), so the admin user can be turned off (acr admin_enabled = false)
# once AKS pulls through its kubelet identity (aks attach_acr).
################################################################################

data "azurerm_container_registry_scope_map" "push" {
  name                    = "_repositories_push"
  container_registry_name = var.containerregistry_name
  resource_group_name     = var.resource_group_name
}

resource "azurerm_container_registry_token" "this" {
  name                    = var.token_name
  container_registry_name = var.containerregistry_name
  resource_group_name     = var.resource_group_name
  scope_map_id            = data.azurerm_container_registry_scope_map.push.id
  enabled                 = true
}

resource "azurerm_container_registry_token_password" "this" {
  container_registry_token_id = azurerm_container_registry_token.this.id

  password1 {
    expiry = var.password_expiry
  }
}
