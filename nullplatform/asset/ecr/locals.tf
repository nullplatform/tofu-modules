locals {
  pull_accounts = concat([data.aws_caller_identity.current.account_id], var.repository_policy_pull_accounts)

  setup_policy = var.enable_cross_account_pull ? {
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Sid       = "AllowPull"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer"
        ]
        Condition = {
          StringEquals = {
            "aws:PrincipalAccount" = local.pull_accounts
          }
        }
      }]
    })
  } : {}
}