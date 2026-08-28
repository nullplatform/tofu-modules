# Module: s3

## Description

Grants an IAM group permission to read and write build assets to a specified S3 bucket by creating and attaching an IAM policy

## Architecture

The module creates an aws_iam_policy resource that allows s3:PutObject and s3:GetObject actions on a specified S3 bucket ARN, scoped with the cluster name for namespacing. The policy is then attached to an existing IAM group via an aws_iam_group_policy_attachment resource, using the group name passed in as input. No new users, roles, or buckets are created; the module solely wires permissions between an existing group and an existing bucket.

## Features

- Creates a cluster-namespaced aws_iam_policy granting PutObject and GetObject access to a specified S3 bucket
- Attaches the S3 assets policy to an existing IAM group via aws_iam_group_policy_attachment
- Scopes S3 access to all objects within the target bucket using a wildcard resource ARN

## Basic Usage

```hcl
module "s3" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/s3?ref=v6.20.0"

  bucket                    = "your-bucket"
  build_workflow_group_name = "your-build-workflow-group-name"
  cluster_name              = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.s3.id
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
| [aws_iam_group_policy_attachment.s3_policy_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.nullplatform_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Name of the S3 bucket where build assets (e.g. Lambda zips) are published. The bucket is managed elsewhere; this module only grants the build workflow group permission to write to it. | `string` | n/a | yes |
| <a name="input_build_workflow_group_name"></a> [build\_workflow\_group\_name](#input\_build\_workflow\_group\_name) | Name of the IAM group (from the ci-build-workflow-user module) to which the S3 assets policy is attached. The build workflow user is a member of this group. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster, used to namespace IAM resource names | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "s3",
  "description": "Grants an IAM group permission to read and write build assets to a specified S3 bucket by creating and attaching an IAM policy",
  "architecture": "The module creates an aws_iam_policy resource that allows s3:PutObject and s3:GetObject actions on a specified S3 bucket ARN, scoped with the cluster name for namespacing. The policy is then attached to an existing IAM group via an aws_iam_group_policy_attachment resource, using the group name passed in as input. No new users, roles, or buckets are created; the module solely wires permissions between an existing group and an existing bucket.",
  "features": [
    "Creates a cluster-namespaced aws_iam_policy granting PutObject and GetObject access to a specified S3 bucket",
    "Attaches the S3 assets policy to an existing IAM group via aws_iam_group_policy_attachment",
    "Scopes S3 access to all objects within the target bucket using a wildcard resource ARN"
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
      "name": "bucket",
      "description": "Name of the S3 bucket where build assets (e.g. Lambda zips) are published. The bucket is managed elsewhere; this module only grants the build workflow group permission to write to it.",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "a11ede543e34569de6169c538b02b09a"
}
END_AI_METADATA -->
