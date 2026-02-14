output "s3_bucket_name" {
  value       = aws_s3_bucket.tf_state.id
  description = "Name of the S3 bucket for Terraform state storage"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.tf_state.arn
  description = "ARN of the S3 bucket for Terraform state storage"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.tf_state_lock.name
  description = "Name of the DynamoDB table for state locking"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.tf_state_lock.arn
  description = "ARN of the DynamoDB table for state locking"
}

output "aws_region" {
  value       = var.aws_region
  description = "AWS region where the backend resources are deployed"
}
