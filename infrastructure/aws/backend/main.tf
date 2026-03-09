data "aws_caller_identity" "current" {}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "tf_state" {
  bucket        = "${var.bucket_prefix}-${lower(random_id.bucket_suffix.hex)}"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_sse" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.create_kms_key ? "aws:kms" : var.sse_algorithm
      kms_master_key_id = var.create_kms_key ? aws_kms_key.s3[0].arn : var.kms_key_id
    }
    bucket_key_enabled = var.create_kms_key
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

###############################################################################
# KMS Key (optional, created when create_kms_key = true)
###############################################################################

resource "aws_kms_key" "s3" {
  count                   = var.create_kms_key ? 1 : 0
  description             = "KMS key for S3 backend bucket encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [{
        Sid       = "RootAccess"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action    = "kms:*"
        Resource  = "*"
      }],
      length(var.allowed_iam_arns) > 0 ? [{
        Sid       = "AllowS3Access"
        Effect    = "Allow"
        Principal = { AWS = var.allowed_iam_arns }
        Action    = ["kms:Decrypt", "kms:GenerateDataKey"]
        Resource  = "*"
      }] : []
    )
  })
}

resource "aws_kms_alias" "s3" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${var.bucket_prefix}-s3-key"
  target_key_id = aws_kms_key.s3[0].key_id
}

###############################################################################
# Bucket Policy (optional, created only when allowed_iam_arns is specified)
###############################################################################

resource "aws_s3_bucket_policy" "tf_state" {
  count  = length(var.allowed_iam_arns) > 0 ? 1 : 0
  bucket = aws_s3_bucket.tf_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowIAMAccess"
        Effect    = "Allow"
        Principal = { AWS = var.allowed_iam_arns }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.tf_state.arn,
          "${aws_s3_bucket.tf_state.arn}/*"
        ]
      },
      {
        Sid       = "DenyNonSSLAccess"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.tf_state.arn,
          "${aws_s3_bucket.tf_state.arn}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      }
    ]
  })
}
