locals {
  github_oidc_url          = "https://token.actions.githubusercontent.com"
  github_oidc_provider_arn = var.github_organization == null ? null : (var.create_github_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn)

  application_manager_statement = {
    Effect    = "Allow",
    Principal = { AWS = var.application_manager_assume_role },
    Action    = "sts:AssumeRole",
  }

  # `np asset push` runs on the GitHub Actions runner, which has no AWS identity:
  # it assumes the role with the job's OIDC token, limited to the organization
  # nullplatform creates application repositories in.
  # GitHub issues the sub claim in two formats depending on the repository:
  # "repo:<org>/<repo>:..." and, with immutable subjects enabled,
  # "repo:<org>@<org_id>/<repo>@<repo_id>:...". Both are accepted; the org id is
  # pinned when github_organization_id is set.
  github_statements = [for org in compact([var.github_organization]) : {
    Effect    = "Allow",
    Principal = { Federated = local.github_oidc_provider_arn },
    Action    = "sts:AssumeRoleWithWebIdentity",
    Condition = {
      StringEquals = { "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com" }
      StringLike = { "token.actions.githubusercontent.com:sub" = [
        "repo:${org}/*",
        "repo:${org}@${coalesce(var.github_organization_id, "*")}/*",
      ] }
    }
  }]
}

# An AWS account holds a single OIDC provider per issuer URL, so by default the
# existing GitHub Actions provider is looked up instead of created.
resource "aws_iam_openid_connect_provider" "github" {
  count = var.github_organization != null && var.create_github_oidc_provider ? 1 : 0

  url            = local.github_oidc_url
  client_id_list = ["sts.amazonaws.com"]
  # AWS validates GitHub's issuer against its own trusted CA library and
  # ignores these, but older AWS providers still require the argument.
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.github_organization != null && !var.create_github_oidc_provider ? 1 : 0

  url = local.github_oidc_url
}

# Replaces the ci-build-workflow-user access keys. Asset-repository permission
# modules (ecr, s3-assets) attach their policies to it through
# build_workflow_role_name.
resource "aws_iam_role" "nullplatform_build_workflow_role" {
  name = "nullplatform-${var.cluster_name}-build-workflow-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = concat([local.application_manager_statement], local.github_statements)
  })
}
