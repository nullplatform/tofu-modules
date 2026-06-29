# Module: s3-assets

## Description

Creates and attaches an IAM policy granting S3 PutObject and GetObject permissions on a specified assets bucket to an existing IAM group used by build workflows

## Architecture

This module creates an aws_iam_policy resource named with the cluster_name prefix that allows s3:PutObject and s3:GetObject actions scoped to the provided assets_bucket. The policy is then attached to an existing IAM group via an aws_iam_group_policy_attachment resource, linking the policy ARN to the group specified by build_workflow_group_name. No new users or groups are created; the module only manages the policy and its attachment to an externally managed group.

## Features

- Creates an aws_iam_policy scoped to PutObject and GetObject actions on the specified S3 assets bucket
- Attaches the created IAM policy to an existing IAM group via aws_iam_group_policy_attachment
- Namespaces the IAM policy name using the cluster_name variable to avoid naming collisions across clusters
- Grants build workflow users inherited S3 access through group membership rather than direct user policy attachment

## Basic Usage

```hcl
module "s3-assets" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/s3-assets?ref=v5.3.0"

  assets_bucket             = "your-assets-bucket"
  build_workflow_group_name = "your-build-workflow-group-name"
  cluster_name              = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.s3-assets.id
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
| <a name="input_build_workflow_group_name"></a> [build\_workflow\_group\_name](#input\_build\_workflow\_group\_name) | Name of the IAM group (from the ci-build-workflow-user module) to which the S3 assets policy is attached. The build workflow user is a member of this group. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster, used to namespace IAM resource names | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "s3-assets",
  "description": "Creates and attaches an IAM policy granting S3 PutObject and GetObject permissions on a specified assets bucket to an existing IAM group used by build workflows",
  "architecture": "This module creates an aws_iam_policy resource named with the cluster_name prefix that allows s3:PutObject and s3:GetObject actions scoped to the provided assets_bucket. The policy is then attached to an existing IAM group via an aws_iam_group_policy_attachment resource, linking the policy ARN to the group specified by build_workflow_group_name. No new users or groups are created; the module only manages the policy and its attachment to an externally managed group.",
  "features": [
    "Creates an aws_iam_policy scoped to PutObject and GetObject actions on the specified S3 assets bucket",
    "Attaches the created IAM policy to an existing IAM group via aws_iam_group_policy_attachment",
    "Namespaces the IAM policy name using the cluster_name variable to avoid naming collisions across clusters",
    "Grants build workflow users inherited S3 access through group membership rather than direct user policy attachment"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster, used to namespace IAM resource names",
      "required": true
    },
    {
      "name": "build_workflow_group_name",
      "description": "Name of the IAM group (from the ci-build-workflow-user module) to which the S3 assets policy is attached. The build workflow user is a member of this group.",
      "required": true
    },
    {
      "name": "assets_bucket",
      "description": "Name of the S3 bucket where build assets (e.g. Lambda zips) are published. The bucket is managed elsewhere; this module only grants the build workflow group permission to write to it.",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "8a89e66cfee86c54f5a8aa097c91ca1b"
}
END_AI_METADATA -->
