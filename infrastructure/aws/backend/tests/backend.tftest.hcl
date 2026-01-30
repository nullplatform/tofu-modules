mock_provider "aws" {}

run "s3_object_lock_enabled" {
  command = plan

  assert {
    condition     = aws_s3_bucket.tf_state.object_lock_enabled == true
    error_message = "S3 bucket should have object lock enabled"
  }
}

run "versioning_enabled" {
  command = plan

  assert {
    condition     = aws_s3_bucket_versioning.tf_state_versioning.versioning_configuration[0].status == "Enabled"
    error_message = "S3 bucket versioning should be enabled"
  }
}

run "sse_aes256" {
  command = plan

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.tf_state_sse.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "S3 bucket should use AES256 server-side encryption"
  }
}

run "object_lock_compliance_mode" {
  command = plan

  assert {
    condition     = one(aws_s3_bucket_object_lock_configuration.tf_state_lock.rule).default_retention[0].mode == "COMPLIANCE"
    error_message = "Object lock should use COMPLIANCE mode"
  }

  assert {
    condition     = one(aws_s3_bucket_object_lock_configuration.tf_state_lock.rule).default_retention[0].days == 1
    error_message = "Object lock retention should be 1 day"
  }
}

run "force_destroy_enabled" {
  command = plan

  assert {
    condition     = aws_s3_bucket.tf_state.force_destroy == true
    error_message = "S3 bucket should have force_destroy enabled"
  }
}
