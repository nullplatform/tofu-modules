resource "terraform_data" "validations" {
  lifecycle {
    precondition {
      condition     = !var.enable_cross_account_pull || length(var.pull_account_ids) > 0
      error_message = "pull_account_ids must have at least one account when enable_cross_account_pull is true."
    }
  }
}
