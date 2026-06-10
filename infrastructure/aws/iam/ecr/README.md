# Module: ecr

## Description

Provisions IAM resources for ECR image management and optional cross-account ECR pull access within a named cluster namespace

## Architecture

The module creates two aws_iam_role resources (an application role with a configurable assume-role principal and an optional cross-account pull role), an aws_iam_policy for ECR management actions, and an aws_iam_user with an aws_iam_access_key for CI/CD build workflows. The ECR manager policy is attached to both the application role via aws_iam_role_policy_attachment and to an aws_iam_group via aws_iam_group_policy_attachment, with the build workflow user added to that group through aws_iam_user_group_membership. When enable_cross_account_pull is true, a separate aws_iam_role and aws_iam_policy scoped to read-only ECR actions are created and linked, with pull_account_ids driving the Principal trust statements.

## Features

- Creates a namespaced aws_iam_role for application image pulling with a configurable assume-role principal
- Creates an aws_iam_policy granting full ECR repository lifecycle permissions including push, pull, and repository management
- Creates an aws_iam_user and aws_iam_access_key for CI/CD build workflow authentication to ECR
- Creates an aws_iam_group and attaches the ECR manager policy for group-based permission management
- Optionally creates a cross-account aws_iam_role and read-only ECR pull policy for external AWS accounts
- Outputs a ready-to-use ECR repository policy JSON for cross-account pull access configuration

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ecr?ref=v4.1.0"

  cluster_name = "your-cluster-name"
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
| [aws_iam_access_key.nullplatform_build_workflow_user_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_group.nullplatform_ecr_managers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy_attachment.ecr_manager_policy_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.ecr_cross_account_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.nullplatform_ecr_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecr_cross_account_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.nullplatform_application_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecr_cross_account_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecr_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.nullplatform_build_workflow_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.build_workflow_ecr_managers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |
| [terraform_data.validations](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_manager_assume_role"></a> [application\_manager\_assume\_role](#input\_application\_manager\_assume\_role) | ARN of the IAM role assumed by the application manager | `string` | `"arn:aws:iam::283477532906:role/application_manager"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster, used to namespace IAM resource names | `string` | n/a | yes |
| <a name="input_enable_cross_account_pull"></a> [enable\_cross\_account\_pull](#input\_enable\_cross\_account\_pull) | Enable cross-account ECR pull access by creating an IAM role that external accounts can assume | `bool` | `false` | no |
| <a name="input_pull_account_ids"></a> [pull\_account\_ids](#input\_pull\_account\_ids) | AWS account IDs allowed to assume the cross-account ECR pull role. Required when enable\_cross\_account\_pull is true. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_role_arn"></a> [application\_role\_arn](#output\_application\_role\_arn) | ARN of the IAM role used by applications to pull ECR images |
| <a name="output_build_workflow_access_key_id"></a> [build\_workflow\_access\_key\_id](#output\_build\_workflow\_access\_key\_id) | Access key ID for the CI/CD build workflow IAM user |
| <a name="output_build_workflow_access_key_secret"></a> [build\_workflow\_access\_key\_secret](#output\_build\_workflow\_access\_key\_secret) | Secret access key for the CI/CD build workflow IAM user |
| <a name="output_cross_account_pull_role_arn"></a> [cross\_account\_pull\_role\_arn](#output\_cross\_account\_pull\_role\_arn) | ARN of the IAM role that cross-account principals can assume to pull ECR images. Empty string when enable\_cross\_account\_pull is false. |
| <a name="output_ecr_repository_policy"></a> [ecr\_repository\_policy](#output\_ecr\_repository\_policy) | ECR repository policy JSON granting pull access to the configured cross-account IDs. Empty string when enable\_cross\_account\_pull is false. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Provisions IAM resources for ECR image management and optional cross-account ECR pull access within a named cluster namespace",
  "architecture": "The module creates two aws_iam_role resources (an application role with a configurable assume-role principal and an optional cross-account pull role), an aws_iam_policy for ECR management actions, and an aws_iam_user with an aws_iam_access_key for CI/CD build workflows. The ECR manager policy is attached to both the application role via aws_iam_role_policy_attachment and to an aws_iam_group via aws_iam_group_policy_attachment, with the build workflow user added to that group through aws_iam_user_group_membership. When enable_cross_account_pull is true, a separate aws_iam_role and aws_iam_policy scoped to read-only ECR actions are created and linked, with pull_account_ids driving the Principal trust statements.",
  "features": [
    "Creates a namespaced aws_iam_role for application image pulling with a configurable assume-role principal",
    "Creates an aws_iam_policy granting full ECR repository lifecycle permissions including push, pull, and repository management",
    "Creates an aws_iam_user and aws_iam_access_key for CI/CD build workflow authentication to ECR",
    "Creates an aws_iam_group and attaches the ECR manager policy for group-based permission management",
    "Optionally creates a cross-account aws_iam_role and read-only ECR pull policy for external AWS accounts",
    "Outputs a ready-to-use ECR repository policy JSON for cross-account pull access configuration"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster, used to namespace IAM resource names",
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
    "build_workflow_access_key_id",
    "build_workflow_access_key_secret",
    "cross_account_pull_role_arn",
    "ecr_repository_policy"
  ],
  "hash": "3fec1e27ab807f00fd3468e628c7cae3"
}
END_AI_METADATA -->
