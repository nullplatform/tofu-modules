resource "terraform_data" "validations" {
  lifecycle {
    precondition {
      condition     = !var.enable_cross_account_pull || length(var.pull_account_ids) > 0
      error_message = "pull_account_ids must have at least one account when enable_cross_account_pull is true."
    }

    precondition {
      condition     = var.build_workflow_group_name != null || var.build_workflow_role_name != null
      error_message = "the ECR manager policy needs a build workflow identity: set build_workflow_role_name, build_workflow_group_name, or both"
    }
  }
}
