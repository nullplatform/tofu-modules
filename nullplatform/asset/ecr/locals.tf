locals {
  pull_accounts = concat([data.aws_caller_identity.current.account_id], var.repository_policy_pull_accounts)
}