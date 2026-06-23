# Module: build-user

## Description

Provisions the shared CI/CD build workflow IAM identity (user, access key, and group) used to publish application assets to any asset repository (ECR, S3, etc.)

## Architecture

The module creates a single `aws_iam_user` with an `aws_iam_access_key` for CI/CD build workflows, plus an `aws_iam_group` named `asset-publishers` and the `aws_iam_user_group_membership` that adds the user to it. The group is the attachment point for per-destination permission modules: `infrastructure/aws/iam/ecr` attaches its ECR policy to this group, and `infrastructure/aws/iam/s3-assets` attaches its S3 policy to the same group. The build user therefore accumulates the permissions of every enabled destination through a single group, which matches how the platform CLI publishes assets (one credential set used for all asset types).

## Features

- Creates a single namespaced `aws_iam_user` and `aws_iam_access_key` for CI/CD build workflow authentication
- Creates a destination-agnostic `aws_iam_group` (`asset-publishers`) that permission modules attach their policies to
- Adds the build user to the group via `aws_iam_user_group_membership`
- Exposes `group_name` so asset-repository modules (`ecr`, `s3-assets`) can grant permissions without recreating the identity

## Basic Usage

```hcl
module "build_user" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/build-user?ref=v5.0.0"

  cluster_name = "your-cluster-name"
}
```

The `group_name` output is consumed by the asset-repository permission modules:

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ecr?ref=v5.0.0"

  cluster_name              = "your-cluster-name"
  build_workflow_group_name = module.build_user.group_name
}

module "s3_assets" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/s3-assets?ref=v5.0.0"

  cluster_name              = "your-cluster-name"
  build_workflow_group_name = module.build_user.group_name
  assets_bucket             = "your-assets-bucket"
}
```

## Migration from < v5.0.0 (build user previously created by `iam/ecr`)

Before v5.0.0 the build workflow user, its access key and the group lived inside the `iam/ecr`
module. This module extracts them. To migrate **without rotating the access keys** (which would
break CI), move the user and its access key in state — the group is renamed
(`ecr-managers` → `asset-publishers`) and is recreated, which does not affect the user's credentials:

```bash
tofu state mv 'module.ecr.aws_iam_user.nullplatform_build_workflow_user' \
              'module.build_user.aws_iam_user.nullplatform_build_workflow_user'

tofu state mv 'module.ecr.aws_iam_access_key.nullplatform_build_workflow_user_key' \
              'module.build_user.aws_iam_access_key.nullplatform_build_workflow_user_key'
```

After the moves, a `tofu plan` should show **no changes** to the user and access key (only their
state address moved), the group + membership recreated as `asset-publishers`, and the ECR policy
re-attached to the new group.

> **Security note:** the build credentials are read by the platform on each CI run (they are not
> stored as per-repository secrets), so rotating them periodically is a good practice and this
> module makes it easy — regenerate the access key and let the platform re-read the new value.

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.nullplatform_build_workflow_user_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_group.asset_publishers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_user.nullplatform_build_workflow_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.asset_publishers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster, used to namespace IAM resource names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_build_workflow_access_key_id"></a> [build\_workflow\_access\_key\_id](#output\_build\_workflow\_access\_key\_id) | Access key ID for the CI/CD build workflow IAM user |
| <a name="output_build_workflow_access_key_secret"></a> [build\_workflow\_access\_key\_secret](#output\_build\_workflow\_access\_key\_secret) | Secret access key for the CI/CD build workflow IAM user |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | Name of the IAM group that asset-repository permission modules (ecr, s3-assets) attach their policies to. The build workflow user is a member of this group. |
<!-- END_TF_DOCS -->
