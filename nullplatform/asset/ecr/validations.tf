resource "terraform_data" "validations" {
  lifecycle {
    precondition {
      condition     = var.build_workflow_role_arn != null || local.has_build_workflow_keys
      error_message = "the CI/CD build workflow needs credentials: set build_workflow_role_arn, or build_workflow_access_key_id and build_workflow_access_key_secret"
    }

    precondition {
      condition     = (var.build_workflow_access_key_id == null) == (var.build_workflow_access_key_secret == null)
      error_message = "build_workflow_access_key_id and build_workflow_access_key_secret must be set together"
    }
  }
}
