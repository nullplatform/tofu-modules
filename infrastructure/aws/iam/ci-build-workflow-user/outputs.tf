output "build_workflow_access_key_id" {
  description = "Access key ID for the CI/CD build workflow IAM user"
  value       = aws_iam_access_key.nullplatform_build_workflow_user_key.id
}

output "build_workflow_access_key_secret" {
  description = "Secret access key for the CI/CD build workflow IAM user"
  value       = aws_iam_access_key.nullplatform_build_workflow_user_key.secret
  sensitive   = true
}

output "group_name" {
  description = "Name of the IAM group that asset-repository permission modules (ecr, s3-assets) attach their policies to. The build workflow user is a member of this group."
  value       = aws_iam_group.asset_publishers.name
}
