resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  lifecycle {
    precondition {
      condition     = var.scope == null || var.role_definition_name != null
      error_message = "scope is set but role_definition_name is not: set both, or leave both null and use role_assignments."
    }
  }
}

resource "azurerm_federated_identity_credential" "this" {
  name                = "${var.name}-federated"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.this.id
  subject             = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}

# Single role assignment from role_definition_name + scope (the original
# interface). Kept at its own address, behind count, so existing callers keep
# their assignment instead of destroying and recreating it.
resource "azurerm_role_assignment" "this" {
  # Only role_definition_name drives count: it is a literal in practice, while
  # scope is often a resource created in the same apply (unknown at plan).
  count = var.role_definition_name != null ? 1 : 0

  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = azurerm_user_assigned_identity.this.principal_id

  lifecycle {
    precondition {
      condition     = var.scope != null
      error_message = "scope is required when role_definition_name is set."
    }
  }
}

moved {
  from = azurerm_role_assignment.this
  to   = azurerm_role_assignment.this[0]
}

# Additional role assignments, keyed by a caller-chosen static name: the key set
# must be known at plan time, while a scope may only be known after apply (e.g. a
# DNS zone created in the same run).
resource "azurerm_role_assignment" "additional" {
  for_each = var.role_assignments

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}
