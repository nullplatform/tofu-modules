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
  }
}
