resource "aws_iam_policy" "nullplatform_s3_policy" {
  name        = "nullplatform-${var.cluster_name}-s3-policy"
  description = "Policy for publishing build assets (e.g. Lambda zips) to the assets S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::${var.bucket}/*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "s3_policy_group" {
  count = var.build_workflow_group_name != null ? 1 : 0

  group      = var.build_workflow_group_name
  policy_arn = aws_iam_policy.nullplatform_s3_policy.arn
}

moved {
  from = aws_iam_group_policy_attachment.s3_policy_group
  to   = aws_iam_group_policy_attachment.s3_policy_group[0]
}

resource "aws_iam_role_policy_attachment" "s3_policy_build_workflow_role" {
  count = var.build_workflow_role_name != null ? 1 : 0

  role       = var.build_workflow_role_name
  policy_arn = aws_iam_policy.nullplatform_s3_policy.arn
}
