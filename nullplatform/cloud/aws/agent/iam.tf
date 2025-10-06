module "nullplatform-agent-role" {
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
    "nullplatform-route53-policy" = aws_iam_policy.nullplatform-route53-policy.arn,
    "nullplatform-eks-policy"     = aws_iam_policy.nullplatform-eks-policy.arn,
    "nullplatform-elb-policy"     = aws_iam_policy.nullplatform-elb-policy.arn
  }
}

resource "aws_iam_policy" "nullplatform-route53-policy" {
  name        = "nullplatform-route53-policy"
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

resource "aws_iam_policy" "nullplatform-elb-policy" {
  name        = "nullplatform-elb-policy"
  description = "Policy for managing Elastic Load Balancer"
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

resource "aws_iam_policy" "nullplatform-eks-policy" {
  name        = "nullplatform-eks-policy"
  description = "Policy for managing EKS clusters"
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
