output "bucket_id" {
  description = "ID of the S3 bucket to which the policy was applied."
  value       = aws_s3_bucket_policy.this.bucket
}

output "policy_json" {
  description = "The final bucket policy JSON applied to the bucket."
  value       = data.aws_iam_policy_document.merged.json
}
