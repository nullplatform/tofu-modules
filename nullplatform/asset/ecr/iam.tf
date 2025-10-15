resource "aws_iam_role" "nullplatform_application_role" {
  name = "nullplatform-application-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = var.application_manager_assume_role
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = [
              data.aws_region.current.name
            ]
          },
          DateGreaterThan = {
            "aws:CurrentTime" = "2024-01-01T00:00:00Z"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "nullplatform_ecr_manager_policy" {
  name        = "nullplatform-ecr-manager-policy"
  description = "Policy for managing ECR repositories with restricted access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
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
          "ecr:TagResource"
        ],
        Resource = [
          "arn:aws:ecr:*:*:repository/*"
        ],
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = [
              data.aws_region.current.name
            ]
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "sts:GetServiceBearerToken",
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user" "nullplatform_build_workflow_user" {
  name = "nullplatform-build-workflow-user"
}

resource "aws_iam_access_key" "nullplatform_build_workflow_user_key" {
  user = aws_iam_user.nullplatform_build_workflow_user.name
}


resource "aws_iam_role_policy_attachment" "ecr_manager_policy" {
  role       = aws_iam_role.nullplatform_application_role.name
  policy_arn = aws_iam_policy.nullplatform_ecr_manager_policy.arn
}

resource "aws_iam_user_policy_attachment" "ecr_manager_policy_user" {
  user       = aws_iam_user.nullplatform_build_workflow_user.name
  policy_arn = aws_iam_policy.nullplatform_ecr_manager_policy.arn
}