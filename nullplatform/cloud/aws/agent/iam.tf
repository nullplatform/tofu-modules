################################################################################
# IAM Role for Nullplatform Agent Service Account
################################################################################

# Create IAM role with OIDC provider trust for Kubernetes service account
module "nullplatform_agent_role" {
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name            = "nullplatform-agent-role"
  use_name_prefix = false

  oidc_providers = {
    main = {
      provider_arn               = var.aws_iam_openid_connect_provider_arn
      namespace_service_accounts = ["nullplatform-tools:nullplatform-agent"]
    }
  }

  policies = {
    "nullplatform_route53_policy" = aws_iam_policy.nullplatform_route53_policy.arn,
    "nullplatform_eks_policy"     = aws_iam_policy.nullplatform_eks_policy.arn,
    "nullplatform_elb_policy"     = aws_iam_policy.nullplatform_elb_policy.arn
  }
}

################################################################################
# Route53 IAM Policy
################################################################################

# Grant permissions to manage Route53 DNS records for service discovery
resource "aws_iam_policy" "nullplatform_route53_policy" {
  name        = "nullplatform_route53_policy"
  description = "Policy for managing Route53 DNS records"
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
        "Condition" : {
          "StringEquals" : {
            "aws:RequestedRegion" : [
              "us-east-1",
              "us-west-2",
              "eu-west-1"
            ]
          }
        }
      }
    ]
  })
}

################################################################################
# Elastic Load Balancer IAM Policy
################################################################################

# Grant permissions to describe and monitor load balancers and target groups
resource "aws_iam_policy" "nullplatform_elb_policy" {
  name        = "nullplatform_elb_policy"
  description = "Policy for managing Elastic Load Balancer resources"
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
                "us-east-1",
                "us-west-2",
                "eu-west-1"
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
          "Condition" : {
            "StringEquals" : {
              "aws:RequestedRegion" : [
                "us-east-1",
                "us-west-2",
                "eu-west-1"
              ]
            }
          }
        }
      ]
    }
  )
}

################################################################################
# EKS IAM Policy
################################################################################

# Grant permissions to describe and list EKS cluster resources
resource "aws_iam_policy" "nullplatform_eks_policy" {
  name        = "nullplatform_eks_policy"
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
        "Condition" : {
          "StringEquals" : {
            "aws:RequestedRegion" : [
              "us-east-1",
              "us-west-2",
              "eu-west-1"
            ]
          }
        }
      }
    ]
  })
}