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

resource "aws_iam_role_policy_attachment" "ecr_manager_policy" {
  role       = aws_iam_role.nullplatform_application_role.name
  policy_arn = aws_iam_policy.nullplatform_ecr_manager_policy.arn
}

resource "aws_iam_group_policy_attachment" "ecr_manager_policy_group" {
  group      = var.build_workflow_group_name
  policy_arn = aws_iam_policy.nullplatform_ecr_manager_policy.arn
}

