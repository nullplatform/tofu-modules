resource "aws_iam_policy" "nullplatform_s3_assets_policy" {
  name        = "nullplatform-${var.cluster_name}-s3-assets-policy"
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
        Resource = "arn:aws:s3:::${var.assets_bucket}/*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "s3_assets_policy_group" {
  group      = var.build_workflow_group_name
  policy_arn = aws_iam_policy.nullplatform_s3_assets_policy.arn
}
