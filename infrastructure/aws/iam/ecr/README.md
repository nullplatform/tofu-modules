# Module: ecr

## Description

Provisions IAM resources for ECR image management and optional cross-account ECR pull access within a named cluster namespace. The build workflow identity (user, access key, group) lives in the `ci-build-workflow-user` module; this module only grants ECR permissions to that group.

## Architecture

The module creates an aws_iam_role (application role with a configurable assume-role principal) and an aws_iam_policy for ECR management actions. The ECR manager policy is attached to the application role via aws_iam_role_policy_attachment and to the shared build-workflow group via aws_iam_group_policy_attachment. The group itself is created by the `ci-build-workflow-user` module and passed in through `build_workflow_group_name`. When enable_cross_account_pull is true, a separate aws_iam_role and aws_iam_policy scoped to read-only ECR actions are created and linked, with pull_account_ids driving the Principal trust statements.

## Features

- Creates a namespaced aws_iam_role for application image pulling with a configurable assume-role principal
- Creates an aws_iam_policy granting full ECR repository lifecycle permissions including push, pull, and repository management
- Attaches the ECR manager policy to the shared build-workflow group (created by the ci-build-workflow-user module) for group-based permission management
- Optionally creates a cross-account aws_iam_role and read-only ECR pull policy for external AWS accounts
- Outputs a ready-to-use ECR repository policy JSON for cross-account pull access configuration

## Basic Usage

```hcl

module "ci_build_workflow_user" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ci-build-workflow-user?ref=v5.0.0"
  cluster_name = "your-cluster-name"
}

module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ecr?ref=v5.0.0"

  cluster_name              = "your-cluster-name"
  build_workflow_group_name = module.ci_build_workflow_user.group_name
}
```

> **Migration from < v5.0.0:** the build workflow user, access key and group were previously
> created by this module. They now live in `ci-build-workflow-user`. See that module's README for the
> `tofu state mv` steps to migrate without rotating the access keys.

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
  "description": "Provisions IAM resources for ECR image management and optional cross-account ECR pull access within a named cluster namespace. The build workflow identity (user, access key, group) lives in the ci-build-workflow-user module; this module only grants ECR permissions to that group.",
  "architecture": "The module creates an aws_iam_role (application role with a configurable assume-role principal) and an aws_iam_policy for ECR management actions. The ECR manager policy is attached to the application role via aws_iam_role_policy_attachment and to the shared build-workflow group via aws_iam_group_policy_attachment. The group itself is created by the ci-build-workflow-user module and passed in through build_workflow_group_name. When enable_cross_account_pull is true, a separate aws_iam_role and aws_iam_policy scoped to read-only ECR actions are created and linked, with pull_account_ids driving the Principal trust statements.",
  "features": [
    "Creates a namespaced aws_iam_role for application image pulling with a configurable assume-role principal",
    "Creates an aws_iam_policy granting full ECR repository lifecycle permissions including push, pull, and repository management",
    "Attaches the ECR manager policy to the shared build-workflow group (created by the ci-build-workflow-user module) for group-based permission management",
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
  "hash": "regenerate-with-terraform-docs"
}
END_AI_METADATA -->
