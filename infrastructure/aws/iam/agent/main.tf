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

################################################################################
# IAM permissions role assumed by the agent role
################################################################################

# Holds the actual workload policies (Route53, EKS, ELB, AVP). Trusts only the
# agent role, so the IRSA token cannot use these permissions without first
# assuming this role.
resource "aws_iam_role" "nullplatform_agent_permissions" {
  name        = local.permissions_role_name
  description = "Permissions role assumed by the nullplatform agent role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = local.agent_role_arn }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "permissions_route53" {
  role       = aws_iam_role.nullplatform_agent_permissions.name
  policy_arn = aws_iam_policy.nullplatform_route53_policy.arn
}

resource "aws_iam_role_policy_attachment" "permissions_eks" {
  role       = aws_iam_role.nullplatform_agent_permissions.name
  policy_arn = aws_iam_policy.nullplatform_eks_policy.arn
}

resource "aws_iam_role_policy_attachment" "permissions_elb" {
  role       = aws_iam_role.nullplatform_agent_permissions.name
  policy_arn = aws_iam_policy.nullplatform_elb_policy.arn
}

resource "aws_iam_role_policy_attachment" "permissions_avp" {
  role       = aws_iam_role.nullplatform_agent_permissions.name
  policy_arn = aws_iam_policy.nullplatform_avp_policy.arn
}

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
# Route 53 IAM policy
################################################################################

# Grant permissions to manage Route 53 DNS records for service discovery
resource "aws_iam_policy" "nullplatform_route53_policy" {
  name        = "${local.policies_name_prefix}_route53_policy"
  description = "Policy for managing Route 53 DNS records"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*"
        ],

      }
    ]
  })
}

################################################################################
# Elastic Load Balancing (ELB) IAM policy
################################################################################

# Grant permissions to describe and monitor load balancers and target groups
resource "aws_iam_policy" "nullplatform_elb_policy" {
  name        = "${local.policies_name_prefix}_elb_policy"
  description = "Policy for managing Elastic Load Balancing resources"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeTargetGroups"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringEquals" : {
              "aws:RequestedRegion" : [
                data.aws_region.current.region
              ]
            }
          }
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "elasticloadbalancing:DescribeTargetHealth",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:DescribeRules"
          ],
          "Resource" : [
            "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/k8s-nullplatform-*",
            "arn:aws:elasticloadbalancing:*:*:targetgroup/k8s-nullplatform-*"
          ],

        }
      ]
    }
  )
}

################################################################################
# EKS IAM policy
################################################################################

# Grant permissions to describe and list EKS cluster resources
resource "aws_iam_policy" "nullplatform_eks_policy" {
  name        = "${local.policies_name_prefix}_eks_policy"
  description = "Policy for managing EKS cluster resources"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:DescribeAddon",
          "eks:ListAddons"
        ],
        "Resource" : [
          "arn:aws:eks:*:*:cluster/*",
          "arn:aws:eks:*:*:nodegroup/*",
          "arn:aws:eks:*:*:addon/*"
        ],

      }
    ]
  })
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

################################################################################
# AVP policy
################################################################################

# Grant permissions to describe and list EKS cluster resources
resource "aws_iam_policy" "nullplatform_avp_policy" {
  name        = "${local.policies_name_prefix}_avp_policy"
  description = "Policy for managing AVP resources"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "verifiedpermissions:*"
        ],
        "Resource" : "*",

      }
    ]
  })
}
