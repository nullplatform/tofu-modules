output "role_arn" {
  description = "ARN of the CI/CD build workflow IAM role. Pass it to nullplatform/asset/ecr as build_workflow_role_arn."
  value       = aws_iam_role.nullplatform_build_workflow_role.arn
}

output "role_name" {
  description = "Name of the CI/CD build workflow IAM role that asset-repository permission modules (ecr, s3-assets) attach their policies to"
  value       = aws_iam_role.nullplatform_build_workflow_role.name
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider the role trusts (created or looked up). Null when github_organization is not set."
  value       = local.github_oidc_provider_arn
}
