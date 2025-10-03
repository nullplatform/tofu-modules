data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "tf_state" {
  bucket              = "tf-state-${lower(random_id.bucket_suffix.hex)}"
  object_lock_enabled = true
  force_destroy       = true
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
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "tf_state_lock" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 1
    }
  }
}
