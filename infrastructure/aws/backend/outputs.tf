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
