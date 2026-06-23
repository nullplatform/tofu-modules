# Module: s3-assets

## Description

Grants the shared build workflow group permission to publish build assets (e.g. Lambda deployment zips) to an existing S3 assets bucket

## Architecture

The module creates an `aws_iam_policy` allowing `s3:PutObject` and `s3:GetObject` on the objects of a given assets bucket (`arn:aws:s3:::<assets_bucket>/*`) and attaches it to the shared build-workflow group via `aws_iam_group_policy_attachment`. The group is created by the `build-user` module and passed in through `build_workflow_group_name`, so the build workflow user accumulates S3 publishing permissions alongside ECR (and any other destination) through that single group. The bucket itself is managed elsewhere and only referenced by name.

## Features

- Creates a namespaced `aws_iam_policy` scoped to `s3:PutObject`/`s3:GetObject` on the assets bucket objects
- Attaches the policy to the shared build-workflow group (created by the build-user module)
- Keeps the bucket out of scope: it is referenced by name, not created or managed here

## Basic Usage

```hcl
module "build_user" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/build-user?ref=v5.0.0"

  cluster_name = "your-cluster-name"
}

module "s3_assets" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/s3-assets?ref=v5.0.0"

  cluster_name              = "your-cluster-name"
  build_workflow_group_name = module.build_user.group_name
  assets_bucket             = "your-assets-bucket"
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_group_policy_attachment.s3_assets_policy_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.nullplatform_s3_assets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assets_bucket"></a> [assets\_bucket](#input\_assets\_bucket) | Name of the S3 bucket where build assets (e.g. Lambda zips) are published. The bucket is managed elsewhere; this module only grants the build workflow group permission to write to it. | `string` | n/a | yes |
| <a name="input_build_workflow_group_name"></a> [build\_workflow\_group\_name](#input\_build\_workflow\_group\_name) | Name of the IAM group (from the build-user module) to which the S3 assets policy is attached. The build workflow user is a member of this group. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster, used to namespace IAM resource names | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
