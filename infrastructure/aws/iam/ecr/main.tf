resource "aws_iam_role" "nullplatform_application_role" {
  name = "nullplatform-${var.cluster_name}-application-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { AWS = var.application_manager_assume_role },
      Action    = "sts:AssumeRole",
    }]
  })
}

resource "aws_iam_policy" "nullplatform_ecr_manager_policy" {
  name        = "nullplatform-${var.cluster_name}-ecr-manager-policy"
  description = "Policy for managing ECR repositories with restricted access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:DescribeRepositories",
          "ecr:TagResource",
          "ecr:SetRepositoryPolicy"
        ]
        Resource = ["arn:aws:ecr:*:*:repository/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["sts:GetServiceBearerToken", "ecr:GetAuthorizationToken"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user" "nullplatform_build_workflow_user" {
  name = "nullplatform-${var.cluster_name}-build-workflow-user"
}

resource "aws_iam_access_key" "nullplatform_build_workflow_user_key" {
  user = aws_iam_user.nullplatform_build_workflow_user.name
}

resource "aws_iam_role_policy_attachment" "ecr_manager_policy" {
  role       = aws_iam_role.nullplatform_application_role.name
  policy_arn = aws_iam_policy.nullplatform_ecr_manager_policy.arn
}

resource "aws_iam_group" "nullplatform_ecr_managers" {
  name = "nullplatform-${var.cluster_name}-ecr-managers"
}

resource "aws_iam_group_policy_attachment" "ecr_manager_policy_group" {
  group      = aws_iam_group.nullplatform_ecr_managers.name
  policy_arn = aws_iam_policy.nullplatform_ecr_manager_policy.arn
}

resource "aws_iam_user_group_membership" "build_workflow_ecr_managers" {
  user   = aws_iam_user.nullplatform_build_workflow_user.name
  groups = [aws_iam_group.nullplatform_ecr_managers.name]
}

resource "aws_iam_role" "ecr_cross_account_pull" {
  count = var.enable_cross_account_pull ? 1 : 0
  name  = "nullplatform-${var.cluster_name}-ecr-cross-account-pull"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = [for id in var.pull_account_ids : "arn:aws:iam::${id}:root"]
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ecr_cross_account_pull" {
  count       = var.enable_cross_account_pull ? 1 : 0
  name        = "nullplatform-${var.cluster_name}-ecr-cross-account-pull-policy"
  description = "Allows cross-account principals to pull images from ECR"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories"
        ]
        Resource = "arn:aws:ecr:*:*:repository/*"
      },
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_cross_account_pull" {
  count      = var.enable_cross_account_pull ? 1 : 0
  role       = aws_iam_role.ecr_cross_account_pull[0].name
  policy_arn = aws_iam_policy.ecr_cross_account_pull[0].arn
}
