resource "aws_iam_role" "ecr_cross_account_pull" {
  name = "nullplatform-${var.cluster_name}-ecr-cross-account-pull"

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
  role       = aws_iam_role.ecr_cross_account_pull.name
  policy_arn = aws_iam_policy.ecr_cross_account_pull.arn
}
