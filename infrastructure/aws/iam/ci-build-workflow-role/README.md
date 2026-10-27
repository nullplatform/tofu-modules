# Module: ci-build-workflow-role

## Description

Creates an AWS IAM role the CI/CD build workflow assumes to publish build assets, replacing the long-lived access keys of the ci-build-workflow-user module

## Architecture

The module creates an aws_iam_role named with the cluster_name prefix. Its trust policy always allows sts:AssumeRole from nullplatform's application manager role, and, when github_organization is set, sts:AssumeRoleWithWebIdentity from the GitHub Actions OIDC provider for any repository of that organization (sub `repo:<org>/*`, aud `sts.amazonaws.com`). `np asset push` runs on the GitHub Actions runner, which has no AWS identity of its own, so it exchanges the job's OIDC token for temporary credentials of this role. The OIDC provider is looked up by default (an account holds one per issuer URL) and created only when create_github_oidc_provider is true. The role carries no permissions of its own: asset-repository permission modules (ecr, s3-assets) attach their policies to it through build_workflow_role_name. Its ARN is passed to nullplatform/asset/ecr as build_workflow_role_arn.

## Basic Usage

```hcl
module "ci_build_workflow_role" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ci-build-workflow-role?ref=vX.Y.Z"

  cluster_name        = "your-cluster-name"
  github_organization = "your-github-org" # same as code_repository's github_organization
}

module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ecr?ref=vX.Y.Z"

  cluster_name             = "your-cluster-name"
  build_workflow_role_name = module.ci_build_workflow_role.role_name
}
```

## Migrating from ci-build-workflow-user

1. Add this module and pass `build_workflow_role_name` to `ecr` / `s3-assets` **next to** the existing `build_workflow_group_name`, and `build_workflow_role_arn` to `nullplatform/asset/ecr` next to the access keys. Apply.
2. Validate an asset push from a GitHub Actions workflow (it needs `permissions: id-token: write`): once a role is configured the platform ignores the keys.
3. Remove `build_workflow_group_name`, the access keys and the `ci-build-workflow-user` module. Apply (this deletes the IAM user and its access key).

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
