resource "terraform_data" "validations" {
  lifecycle {
    # Only an explicit attach_acr=true forces the attachment, so only then is acr_id required;
    # null (legacy, gated on acr_id itself) and false need no id. Guards against the { acr = null }
    # map that would feed null into azurerm_role_assignment's required scope. When acr_id is
    # known-after-apply the condition is unknown and OpenTofu defers the check to apply time,
    # so the greenfield single-apply path is unaffected.
    precondition {
      condition     = var.attach_acr != true || var.acr_id != null
      error_message = "acr_id is required when attach_acr is true. Leave attach_acr null (legacy) or set it false for clusters without an ACR."
    }

    # Disabling local accounts removes the certificate-based admin path, leaving Entra ID as the only
    # way in. Without Azure RBAC or an admin group, no identity is authorized against the API server:
    # the cluster stays reachable only through whatever admin kubeconfig was issued beforehand, and
    # becomes unrecoverable from configuration once that credential stops working.
    precondition {
      condition     = var.local_account_disabled != true || var.azure_rbac_enabled || try(length(var.admin_group_object_ids), 0) > 0
      error_message = "local_account_disabled = true removes the only certificate-based path into the cluster. Set azure_rbac_enabled = true, or provide admin_group_object_ids, so at least one Entra ID identity stays authorized."
    }
  }
}
