locals {
  # IAM condition keys for an OIDC provider are its issuer URL without the scheme.
  oidc_hosts = { for k, p in var.oidc_providers : k => trimprefix(p.url, "https://") }

  oidc_provider_arns = merge(
    { for k, p in aws_iam_openid_connect_provider.this : k => p.arn },
    { for k, p in data.aws_iam_openid_connect_provider.this : k => p.arn },
  )

  application_manager_statement = {
    Effect    = "Allow",
    Principal = { AWS = var.application_manager_assume_role },
    Action    = "sts:AssumeRole",
  }

  # `np asset push` runs on the CI runner, which has no AWS identity: it
  # exchanges the job's OIDC token for the role's credentials, either requested
  # by the CLI itself (GitHub Actions) or read from AWS_WEB_IDENTITY_TOKEN_FILE
  # (GitLab CI, Bitbucket Pipelines and any other tool that issues OIDC tokens).
  oidc_statements = [for k, p in var.oidc_providers : {
    Effect    = "Allow",
    Principal = { Federated = local.oidc_provider_arns[k] },
    Action    = "sts:AssumeRoleWithWebIdentity",
    Condition = {
      StringEquals = { "${local.oidc_hosts[k]}:aud" = p.audiences }
      StringLike   = { "${local.oidc_hosts[k]}:sub" = p.subjects }
    }
  }]
}

# An AWS account holds a single OIDC provider per issuer URL, so by default an
# existing one is looked up and only created when asked to.
resource "aws_iam_openid_connect_provider" "this" {
  for_each = { for k, p in var.oidc_providers : k => p if p.create }

  url            = each.value.url
  client_id_list = each.value.audiences
  # AWS validates issuers with publicly trusted certificates against its own CA
  # library; thumbprints are only needed for self-managed issuers.
  thumbprint_list = length(each.value.thumbprints) > 0 ? each.value.thumbprints : null
}

data "aws_iam_openid_connect_provider" "this" {
  for_each = { for k, p in var.oidc_providers : k => p if !p.create }

  url = each.value.url
}

# Replaces the ci-build-workflow-user access keys. Asset-repository permission
# modules (ecr, s3-assets) attach their policies to it through
# build_workflow_role_name.
resource "aws_iam_role" "nullplatform_build_workflow_role" {
  name = "nullplatform-${var.cluster_name}-build-workflow-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = concat([local.application_manager_statement], local.oidc_statements)
  })
}
