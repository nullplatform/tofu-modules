mock_provider "aws" {}
mock_provider "random" {}

# --- Default values ---

run "versioning_enabled" {
  command = plan

  assert {
    condition     = aws_s3_bucket_versioning.tf_state_versioning.versioning_configuration[0].status == "Enabled"
    error_message = "S3 bucket versioning should be enabled"
  }
}

run "sse_defaults_to_aes256" {
  command = plan

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.tf_state_sse.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "S3 bucket should default to AES256 server-side encryption"
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.tf_state_sse.rule).apply_server_side_encryption_by_default[0].kms_master_key_id == null
    error_message = "KMS key should be null when using AES256"
  }
}

run "force_destroy_enabled_by_default" {
  command = plan

  assert {
    condition     = aws_s3_bucket.tf_state.force_destroy == true
    error_message = "S3 bucket should have force_destroy enabled by default"
  }
}

run "public_access_blocked" {
  command = plan

  assert {
    condition     = aws_s3_bucket_public_access_block.tf_state.block_public_acls == true
    error_message = "S3 bucket should block public ACLs"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.tf_state.block_public_policy == true
    error_message = "S3 bucket should block public policies"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.tf_state.ignore_public_acls == true
    error_message = "S3 bucket should ignore public ACLs"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.tf_state.restrict_public_buckets == true
    error_message = "S3 bucket should restrict public buckets"
  }
}

run "ownership_controls" {
  command = plan

  assert {
    condition     = one(aws_s3_bucket_ownership_controls.tf_state.rule).object_ownership == "BucketOwnerEnforced"
    error_message = "S3 bucket ownership should be BucketOwnerEnforced"
  }
}

run "bucket_name_uses_prefix" {
  command = plan

  assert {
    condition     = startswith(aws_s3_bucket.tf_state.bucket, "tf-state-")
    error_message = "S3 bucket name should start with the default prefix 'tf-state-'"
  }
}

# --- Custom variable overrides ---

run "custom_bucket_prefix" {
  command = plan

  variables {
    bucket_prefix = "my-backend"
  }

  assert {
    condition     = startswith(aws_s3_bucket.tf_state.bucket, "my-backend-")
    error_message = "S3 bucket name should use the custom prefix"
  }
}

run "force_destroy_disabled" {
  command = plan

  variables {
    force_destroy = false
  }

  assert {
    condition     = aws_s3_bucket.tf_state.force_destroy == false
    error_message = "S3 bucket should respect force_destroy = false"
  }
}

run "sse_with_kms" {
  command = plan

  variables {
    sse_algorithm = "aws:kms"
    kms_key_id    = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.tf_state_sse.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms"
    error_message = "S3 bucket should use aws:kms encryption when configured"
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.tf_state_sse.rule).apply_server_side_encryption_by_default[0].kms_master_key_id == "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
    error_message = "S3 bucket should use the provided KMS key"
  }
}

# --- KMS key ---

run "no_kms_key_by_default" {
  command = plan

  assert {
    condition     = length(aws_kms_key.s3) == 0
    error_message = "KMS key should not be created by default"
  }
}

run "kms_key_created_when_enabled" {
  command = plan

  variables {
    create_kms_key = true
  }

  assert {
    condition     = length(aws_kms_key.s3) == 1
    error_message = "KMS key should be created when create_kms_key is true"
  }

  assert {
    condition     = aws_kms_key.s3[0].enable_key_rotation == true
    error_message = "KMS key should have key rotation enabled"
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.tf_state_sse.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms"
    error_message = "SSE should switch to aws:kms when create_kms_key is true"
  }
}

# --- Bucket policy ---

run "no_bucket_policy_by_default" {
  command = plan

  assert {
    condition     = length(aws_s3_bucket_policy.tf_state) == 0
    error_message = "Bucket policy should not be created when allowed_iam_arns is empty"
  }
}

run "bucket_policy_created_with_iam_arns" {
  command = plan

  variables {
    allowed_iam_arns = ["arn:aws:iam::123456789012:role/terraform-role"]
  }

  assert {
    condition     = length(aws_s3_bucket_policy.tf_state) == 1
    error_message = "Bucket policy should be created when allowed_iam_arns is specified"
  }
}

run "kms_and_iam_together" {
  command = plan

  variables {
    create_kms_key   = true
    allowed_iam_arns = ["arn:aws:iam::123456789012:role/terraform-role"]
  }

  assert {
    condition     = length(aws_kms_key.s3) == 1
    error_message = "KMS key should be created"
  }

  assert {
    condition     = length(aws_s3_bucket_policy.tf_state) == 1
    error_message = "Bucket policy should be created"
  }

  assert {
    condition     = length(aws_kms_alias.s3) == 1
    error_message = "KMS alias should be created"
  }
}

# --- Output validation ---

run "outputs" {
  command = plan

  assert {
    condition     = output.aws_region == "us-east-1"
    error_message = "aws_region output should match the default region"
  }

  assert {
    condition     = output.kms_key_arn == null
    error_message = "kms_key_arn should be null when create_kms_key is false"
  }
}
