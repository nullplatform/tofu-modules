output "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.tf_state.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.tf_state.arn
}

output "aws_region" {
  description = "AWS region where the backend was created"
  value       = var.aws_region
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for bucket encryption (null if not created)"
  value       = var.create_kms_key ? aws_kms_key.s3[0].arn : null
}

output "kms_key_alias" {
  description = "Alias of the KMS key (null if not created)"
  value       = var.create_kms_key ? aws_kms_alias.s3[0].name : null
}
