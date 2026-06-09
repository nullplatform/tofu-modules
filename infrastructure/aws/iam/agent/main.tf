locals {
  role_name            = var.role_name != "" ? var.role_name : "nullplatform-${var.cluster_name}-agent-role"
  policies_name_prefix = var.policies_name_prefix != "" ? var.policies_name_prefix : "nullplatform_${var.cluster_name}"
}

################################################################################
# IAM role for nullplatform agent service account
################################################################################

# Create IAM role with OIDC provider trust for Kubernetes service account
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
      "nullplatform_route53_policy" = aws_iam_policy.nullplatform_route53_policy.arn,
      "nullplatform_eks_policy"     = aws_iam_policy.nullplatform_eks_policy.arn,
      "nullplatform_elb_policy"     = aws_iam_policy.nullplatform_elb_policy.arn,
      "nullplatform_avp_policy"     = aws_iam_policy.nullplatform_avp_policy.arn
    },
    length(var.assume_role_arns) > 0 ? {
      "nullplatform_assume_role_policy" = aws_iam_policy.nullplatform_assume_role_policy[0].arn
    } : {},
    var.additional_policies
  )
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
        # "Condition" : {
        #   "StringEquals" : {
        #     "aws:RequestedRegion" : [
        #       data.aws_region.current.region
        #     ]
        #   }
        # }
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
          # "Condition" : {
          #   "StringEquals" : {
          #     "aws:RequestedRegion" : [
          #       data.aws_region.current.region
          #     ]
          #   }
          # }
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
        # "Condition" : {
        #   "StringEquals" : {
        #     "aws:RequestedRegion" : [
        #       data.aws_region.current.region
        #     ]
        #   }
        # }
      }
    ]
  })
}

################################################################################
# STS AssumeRole IAM policy
################################################################################

resource "aws_iam_policy" "nullplatform_assume_role_policy" {
  count = length(var.assume_role_arns) > 0 ? 1 : 0

  name        = "${local.policies_name_prefix}_assume_role_policy"
  description = "Policy allowing the agent to assume specific IAM roles"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = var.assume_role_arns
    }]
  })
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
        # "Condition" : {
        #   "StringEquals" : {
        #     "aws:RequestedRegion" : [
        #       data.aws_region.current.region
        #     ]
        #   }
        # }
      }
    ]
  })
}
