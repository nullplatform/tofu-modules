locals {
  service_account = "${var.service_account_namespace}:${var.service_account_name}"
}

# IRSA: OIDC federation via community module
module "nullplatform_cloudwatch_role" {
  count           = var.identity_mode == "irsa" ? 1 : 0
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name            = "nullplatform-${var.cluster_name}-cloudwatch-role"
  use_name_prefix = false

  oidc_providers = {
    main = {
      provider_arn               = var.aws_iam_openid_connect_provider_arn
      namespace_service_accounts = [local.service_account]
    }
  }

  policies = {
    "nullplatform_cloudwatch_policy" = aws_iam_policy.nullplatform_cloudwatch_policy.arn,
  }
}

# Pod Identity: native IAM role trusted by the EKS Pod Identity agent
resource "aws_iam_role" "pod_identity" {
  count = var.identity_mode == "pod_identity" ? 1 : 0
  name  = "nullplatform-${var.cluster_name}-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "pod_identity" {
  count      = var.identity_mode == "pod_identity" ? 1 : 0
  role       = one(aws_iam_role.pod_identity[*].name)
  policy_arn = aws_iam_policy.nullplatform_cloudwatch_policy.arn
}

resource "aws_eks_pod_identity_association" "this" {
  count           = var.identity_mode == "pod_identity" ? 1 : 0
  cluster_name    = var.cluster_name
  namespace       = var.service_account_namespace
  service_account = var.service_account_name
  role_arn        = one(aws_iam_role.pod_identity[*].arn)
}

# Grant the logs controller permission to ship logs and metrics to CloudWatch
resource "aws_iam_policy" "nullplatform_cloudwatch_policy" {
  name        = "nullplatform-${var.cluster_name}-cloudwatch-policy"
  description = "Policy for the nullplatform logs controller to ship logs and metrics to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogsWrite"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy",
          "logs:DescribeLogStreams",
          "logs:TagResource",
          "logs:ListTagsForResource"
        ]
        Resource = var.log_group_arn_patterns
      },
      {
        Sid      = "CloudWatchLogsDescribe"
        Effect   = "Allow"
        Action   = ["logs:DescribeLogGroups"]
        Resource = ["*"]
      },
      {
        # cloudwatch:PutMetricData does not support resource-level permissions.
        Sid      = "CloudWatchMetricsWrite"
        Effect   = "Allow"
        Action   = ["cloudwatch:PutMetricData"]
        Resource = ["*"]
      }
    ]
  })
}
