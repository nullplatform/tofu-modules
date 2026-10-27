resource "terraform_data" "validations" {
  lifecycle {
    precondition {
      condition     = var.build_workflow_group_name != null || var.build_workflow_role_name != null
      error_message = "the S3 assets policy needs a build workflow identity: set build_workflow_role_name, build_workflow_group_name, or both"
    }
  }
}
