resource "terraform_data" "validations" {
  lifecycle {
    precondition {
      condition     = !var.enable_cross_account_pull || length(var.repository_policy_pull_accounts) > 0
      error_message = "repository_policy_pull_accounts must have at least one account when enable_cross_account_pull is true."
    }
  }
}
