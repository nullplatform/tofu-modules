# Module: s3

## Description

Grants an IAM group or role write access to a specified S3 bucket for publishing build assets such as Lambda zip files

## Architecture

The module creates an aws_iam_policy resource named with the cluster name that allows s3:PutObject and s3:GetObject on the target bucket. Conditionally, an aws_iam_group_policy_attachment attaches the policy to an IAM group when build_workflow_group_name is provided, and an aws_iam_role_policy_attachment attaches it to an IAM role when build_workflow_role_name is provided. Both attachments are independent and can be active simultaneously to support migration from access-key-based groups to IAM roles.

## Features

- Creates an aws_iam_policy scoped to a named S3 bucket allowing PutObject and GetObject actions
- Attaches the S3 policy to an IAM group via aws_iam_group_policy_attachment when a group name is supplied
- Attaches the S3 policy to an IAM role via aws_iam_role_policy_attachment when a role name is supplied
- Supports simultaneous group and role attachment to enable zero-downtime migration from access keys to IAM roles
- Namespaces the IAM policy name using the cluster name to avoid conflicts across environments

## Basic Usage

```hcl
module "s3" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/s3?ref=v9.9.0"

  bucket       = "your-bucket"
  cluster_name = "your-cluster-name"
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
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_group_policy_attachment.s3_policy_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.nullplatform_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.s3_policy_build_workflow_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [terraform_data.validations](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Name of the S3 bucket where build assets (e.g. Lambda zips) are published. The bucket is managed elsewhere; this module only grants the build workflow group permission to write to it. | `string` | n/a | yes |
| <a name="input_build_workflow_group_name"></a> [build\_workflow\_group\_name](#input\_build\_workflow\_group\_name) | Name of the IAM group (from the ci-build-workflow-user module) to which the S3 assets policy is attached. The build workflow user is a member of this group. Set this, build\_workflow\_role\_name, or both while migrating from access keys to the role. | `string` | `null` | no |
| <a name="input_build_workflow_role_name"></a> [build\_workflow\_role\_name](#input\_build\_workflow\_role\_name) | Name of the IAM role (from the ci-build-workflow-role module) to which the S3 assets policy is attached. Set this, build\_workflow\_group\_name, or both while migrating from access keys to the role. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster, used to namespace IAM resource names | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "s3",
  "description": "Grants an IAM group or role write access to a specified S3 bucket for publishing build assets such as Lambda zip files",
  "architecture": "The module creates an aws_iam_policy resource named with the cluster name that allows s3:PutObject and s3:GetObject on the target bucket. Conditionally, an aws_iam_group_policy_attachment attaches the policy to an IAM group when build_workflow_group_name is provided, and an aws_iam_role_policy_attachment attaches it to an IAM role when build_workflow_role_name is provided. Both attachments are independent and can be active simultaneously to support migration from access-key-based groups to IAM roles.",
  "features": [
    "Creates an aws_iam_policy scoped to a named S3 bucket allowing PutObject and GetObject actions",
    "Attaches the S3 policy to an IAM group via aws_iam_group_policy_attachment when a group name is supplied",
    "Attaches the S3 policy to an IAM role via aws_iam_role_policy_attachment when a role name is supplied",
    "Supports simultaneous group and role attachment to enable zero-downtime migration from access keys to IAM roles",
    "Namespaces the IAM policy name using the cluster name to avoid conflicts across environments"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster, used to namespace IAM resource names",
      "required": true
    },
    {
      "name": "bucket",
      "description": "Name of the S3 bucket where build assets (e.g. Lambda zips) are published. The bucket is managed elsewhere; this module only grants the build workflow group permission to write to it.",
      "required": true
    },
    {
      "name": "build_workflow_group_name",
      "description": "Name of the IAM group (from the ci-build-workflow-user module) to which the S3 assets policy is attached. The build workflow user is a member of this group. Set this, build_workflow_role_name, or both while migrating from access keys to the role.",
      "required": false
    },
    {
      "name": "build_workflow_role_name",
      "description": "Name of the IAM role (from the ci-build-workflow-role module) to which the S3 assets policy is attached. Set this, build_workflow_group_name, or both while migrating from access keys to the role.",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "b17ddf7862e95951aa8bb216cc9e3cf5"
}
END_AI_METADATA -->
