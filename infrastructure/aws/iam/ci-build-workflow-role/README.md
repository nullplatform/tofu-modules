# Module: ci-build-workflow-role

## Description

Creates an AWS IAM role that nullplatform's application manager assumes to publish build assets, replacing the long-lived access keys of the ci-build-workflow-user module

## Architecture

The module creates an aws_iam_role named with the cluster_name prefix whose trust policy allows sts:AssumeRole only from nullplatform's application manager role, the same trust used by the application role in the ecr module. The role carries no permissions of its own: asset-repository permission modules (ecr, s3-assets) attach their policies to it through build_workflow_role_name, the same way they attach them to the ci-build-workflow-user group. Its ARN is passed to nullplatform/asset/ecr as build_workflow_role_arn.

## Basic Usage

```hcl
module "ci_build_workflow_role" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ci-build-workflow-role?ref=vX.Y.Z"

  cluster_name = "your-cluster-name"
}

module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ecr?ref=vX.Y.Z"

  cluster_name             = "your-cluster-name"
  build_workflow_role_name = module.ci_build_workflow_role.role_name
}
```

## Migrating from ci-build-workflow-user

1. Add this module and pass `build_workflow_role_name` to `ecr` / `s3-assets` **next to** the existing `build_workflow_group_name`, and `build_workflow_role_arn` to `nullplatform/asset/ecr` next to the access keys. Apply.
2. Validate an asset push: once a role is configured the platform ignores the keys.
3. Remove `build_workflow_group_name`, the access keys and the `ci-build-workflow-user` module. Apply (this deletes the IAM user and its access key).

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
