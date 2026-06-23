locals {
  role_name             = var.role_name != "" ? var.role_name : "nullplatform-${var.cluster_name}-agent-role"
  permissions_role_name = var.permissions_role_name != "" ? var.permissions_role_name : "nullplatform-${var.cluster_name}-agent-permissions-role"
  policies_name_prefix  = var.policies_name_prefix != "" ? var.policies_name_prefix : "nullplatform_${var.cluster_name}"

  # ARNs built from names + account id to avoid a circular dependency between
  # the agent role (assume policy -> permissions role) and the permissions role
  # (trust policy -> agent role).
  agent_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}"
  permissions_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.permissions_role_name}"

  # Resolve the name and (computed) ARN of each extra permissions role up front,
  # so both the agent assume policy and the role trust policies reference the
  # same deterministic ARN without depending on each other's resources.
  extra_permissions_role_names = {
    for key, cfg in var.permissions_roles : key => coalesce(cfg.name, "nullplatform-${var.cluster_name}-${key}")
  }
  extra_permissions_role_arns = [
    for name in values(local.extra_permissions_role_names) : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${name}"
  ]

  # Flatten the extra permissions roles into one (role, policy_arn) pair per
  # attachment, keyed by "role::arn" so the for_each key is stable regardless of
  # list ordering.
  extra_permissions_attachments = {
    for pair in flatten([
      for role_key, cfg in var.permissions_roles : [
        for arn in cfg.policy_arns : {
          role_key = role_key
          arn      = arn
        }
      ]
    ]) : "${pair.role_key}::${pair.arn}" => pair
  }
}

################################################################################
# IAM role for nullplatform agent service account
################################################################################

# Create IAM role with OIDC provider trust for Kubernetes service account.
# This role only holds an sts:AssumeRole policy: it assumes the permissions
# role (and any additional assume_role_arns) instead of carrying the workload
# policies directly.
module "nullplatform_agent_role" {
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name            = local.role_name
  use_name_prefix = false

  oidc_providers = {
    main = {
      provider_arn               = var.aws_iam_openid_connect_provider_arn
      namespace_service_accounts = ["${var.agent_namespace}:${var.service_account_name}"]
    }
  }

  policies = merge(
    {
      "nullplatform_assume_role_policy" = aws_iam_policy.nullplatform_assume_role_policy.arn
    },
    var.additional_policies
  )
}

# NOTE: The permissions role (nullplatform_agent_permissions) and its workload
# policies (Route53, EKS, ELB, AVP) are no longer created by this module. They
# are now provisioned per-cluster by the k8s scope's OpenTofu module
# (scopes: k8s/scope/tofu/iam/modules). This module keeps only the agent IRSA
# role and an assume policy that authorizes assuming that externally-created
# permissions role by its conventional ARN (see nullplatform_assume_role_policy
# and local.permissions_role_arn).

################################################################################
# Additional permissions roles assumed by the agent role
################################################################################

# Extra permissions roles created on demand via var.permissions_roles. Each one
# trusts only the agent role and gets the provided policy ARNs attached. The
# agent role's assume policy is extended with all of these role ARNs.
resource "aws_iam_role" "extra_permissions" {
  for_each = var.permissions_roles

  name        = local.extra_permissions_role_names[each.key]
  description = "Additional permissions role assumed by the nullplatform agent role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = local.agent_role_arn }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "extra_permissions" {
  for_each = local.extra_permissions_attachments

  role       = aws_iam_role.extra_permissions[each.value.role_key].name
  policy_arn = each.value.arn
}

################################################################################
# STS AssumeRole IAM policy
################################################################################

resource "aws_iam_policy" "nullplatform_assume_role_policy" {
  name        = "${local.policies_name_prefix}_assume_role_policy"
  description = "Policy allowing the agent to assume the permissions role and any additional roles"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Resource = concat(
        [local.permissions_role_arn],
        local.extra_permissions_role_arns,
        var.assume_role_arns
      )
    }]
  })
}

# The assume role policy used to be conditional (count). It is now always
# created because the agent role must be able to assume the permissions role.
moved {
  from = aws_iam_policy.nullplatform_assume_role_policy[0]
  to   = aws_iam_policy.nullplatform_assume_role_policy
}
