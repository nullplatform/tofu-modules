# Module: ci-build-workflow-user

## Description

Creates an AWS IAM user with access keys and an IAM group for CI/CD build workflow asset publishing in a nullplatform cluster

## Architecture

The module creates an aws_iam_user named with the cluster_name prefix and generates an aws_iam_access_key for programmatic access. An aws_iam_group is created to serve as the attachment point for downstream policy modules such as ECR or S3 asset repositories. An aws_iam_user_group_membership resource wires the build workflow user into the asset publishers group, and the access key credentials along with the group name are exposed as outputs for consumption by other modules.

## Features

- Creates a namespaced aws_iam_user for CI/CD build workflow automation scoped to the cluster name
- Generates aws_iam_access_key credentials for programmatic AWS API access by the build workflow user
- Creates an aws_iam_group to serve as a shared attachment point for asset-publishing IAM policies
- Attaches the build workflow user to the asset publishers group via aws_iam_user_group_membership
- Outputs access key ID and sensitive secret key for use in CI/CD pipeline configuration
- Exposes the IAM group name output for policy attachment by downstream ECR and S3 asset modules

## Basic Usage

```hcl
module "ci-build-workflow-user" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ci-build-workflow-user?ref=v6.19.0"

  cluster_name = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.ci-build-workflow-user.build_workflow_access_key_id
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

<!-- BEGIN_AI_METADATA
{
  "name": "ci-build-workflow-user",
  "description": "Creates an AWS IAM user with access keys and an IAM group for CI/CD build workflow asset publishing in a nullplatform cluster",
  "architecture": "The module creates an aws_iam_user named with the cluster_name prefix and generates an aws_iam_access_key for programmatic access. An aws_iam_group is created to serve as the attachment point for downstream policy modules such as ECR or S3 asset repositories. An aws_iam_user_group_membership resource wires the build workflow user into the asset publishers group, and the access key credentials along with the group name are exposed as outputs for consumption by other modules.",
  "features": [
    "Creates a namespaced aws_iam_user for CI/CD build workflow automation scoped to the cluster name",
    "Generates aws_iam_access_key credentials for programmatic AWS API access by the build workflow user",
    "Creates an aws_iam_group to serve as a shared attachment point for asset-publishing IAM policies",
    "Attaches the build workflow user to the asset publishers group via aws_iam_user_group_membership",
    "Outputs access key ID and sensitive secret key for use in CI/CD pipeline configuration",
    "Exposes the IAM group name output for policy attachment by downstream ECR and S3 asset modules"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster, used to namespace IAM resource names",
      "required": true
    }
  ],
  "outputs": [
    "build_workflow_access_key_id",
    "build_workflow_access_key_secret",
    "group_name"
  ],
  "hash": "2c0aef02dbbd6af2dd32f8a3a9f60802"
}
END_AI_METADATA -->
