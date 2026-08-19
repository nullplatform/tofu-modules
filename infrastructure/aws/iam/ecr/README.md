# Module: ecr

## Description

Creates IAM roles and policies for managing ECR repositories and enabling cross-account image pull access in a nullplatform cluster

## Architecture

The module creates an aws_iam_role named nullplatform-{cluster_name}-application-role with a trust policy allowing a configurable application manager role to assume it. An aws_iam_policy granting ECR repository management actions (create, delete, push, pull) is created and attached to the application role via aws_iam_role_policy_attachment, and also attached to an existing IAM group via aws_iam_group_policy_attachment. The ecr_repository_policy output conditionally renders a cross-account ECR repository policy JSON granting pull access to specified AWS account IDs when enable_cross_account_pull is true.

## Features

- Creates aws_iam_role for application workloads with configurable assume-role trust policy
- Creates aws_iam_policy granting full ECR repository lifecycle management including push, pull, create, and delete actions
- Attaches ECR manager policy to the application role via aws_iam_role_policy_attachment
- Attaches ECR manager policy to an existing IAM group via aws_iam_group_policy_attachment for CI build workflow users
- Generates cross-account ECR repository policy JSON allowing specified AWS accounts to pull images when enable_cross_account_pull is enabled

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ecr?ref=v7.0.3"

  build_workflow_group_name = "your-build-workflow-group-name"
  cluster_name              = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.ecr.application_role_arn
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
| [aws_iam_group_policy_attachment.ecr_manager_policy_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.nullplatform_ecr_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.nullplatform_application_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecr_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [terraform_data.validations](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_manager_assume_role"></a> [application\_manager\_assume\_role](#input\_application\_manager\_assume\_role) | ARN of the IAM role assumed by the application manager | `string` | `"arn:aws:iam::283477532906:role/application_manager"` | no |
| <a name="input_build_workflow_group_name"></a> [build\_workflow\_group\_name](#input\_build\_workflow\_group\_name) | Name of the IAM group (from the ci-build-workflow-user module) to which the ECR manager policy is attached. The build workflow user is a member of this group. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster, used to namespace IAM resource names | `string` | n/a | yes |
| <a name="input_enable_cross_account_pull"></a> [enable\_cross\_account\_pull](#input\_enable\_cross\_account\_pull) | Enable cross-account ECR pull access by creating an IAM role that external accounts can assume | `bool` | `false` | no |
| <a name="input_pull_account_ids"></a> [pull\_account\_ids](#input\_pull\_account\_ids) | AWS account IDs allowed to assume the cross-account ECR pull role. Required when enable\_cross\_account\_pull is true. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_role_arn"></a> [application\_role\_arn](#output\_application\_role\_arn) | ARN of the IAM role used by applications to pull ECR images |
| <a name="output_ecr_repository_policy"></a> [ecr\_repository\_policy](#output\_ecr\_repository\_policy) | ECR repository policy JSON granting pull access to the configured cross-account IDs. Empty string when enable\_cross\_account\_pull is false. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Creates IAM roles and policies for managing ECR repositories and enabling cross-account image pull access in a nullplatform cluster",
  "architecture": "The module creates an aws_iam_role named nullplatform-{cluster_name}-application-role with a trust policy allowing a configurable application manager role to assume it. An aws_iam_policy granting ECR repository management actions (create, delete, push, pull) is created and attached to the application role via aws_iam_role_policy_attachment, and also attached to an existing IAM group via aws_iam_group_policy_attachment. The ecr_repository_policy output conditionally renders a cross-account ECR repository policy JSON granting pull access to specified AWS account IDs when enable_cross_account_pull is true.",
  "features": [
    "Creates aws_iam_role for application workloads with configurable assume-role trust policy",
    "Creates aws_iam_policy granting full ECR repository lifecycle management including push, pull, create, and delete actions",
    "Attaches ECR manager policy to the application role via aws_iam_role_policy_attachment",
    "Attaches ECR manager policy to an existing IAM group via aws_iam_group_policy_attachment for CI build workflow users",
    "Generates cross-account ECR repository policy JSON allowing specified AWS accounts to pull images when enable_cross_account_pull is enabled"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster, used to namespace IAM resource names",
      "required": true
    },
    {
      "name": "build_workflow_group_name",
      "description": "Name of the IAM group (from the ci-build-workflow-user module) to which the ECR manager policy is attached. The build workflow user is a member of this group.",
      "required": true
    },
    {
      "name": "application_manager_assume_role",
      "description": "ARN of the IAM role assumed by the application manager",
      "required": false
    },
    {
      "name": "enable_cross_account_pull",
      "description": "Enable cross-account ECR pull access by creating an IAM role that external accounts can assume",
      "required": false
    },
    {
      "name": "pull_account_ids",
      "description": "AWS account IDs allowed to assume the cross-account ECR pull role. Required when enable_cross_account_pull is true.",
      "required": false
    }
  ],
  "outputs": [
    "application_role_arn",
    "ecr_repository_policy"
  ],
  "hash": "60331cc847b22eed0125b050bbcbec83"
}
END_AI_METADATA -->
