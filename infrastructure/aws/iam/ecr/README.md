# Module: ecr

## Description

Provisions IAM roles and policies to enable ECR repository management and cross-account image pull access for nullplatform application clusters

## Architecture

The module creates an aws_iam_role (nullplatform application role) with a configurable assume-role policy and an aws_iam_policy granting full ECR repository lifecycle permissions. The ECR policy is attached to the application role via aws_iam_role_policy_attachment, and conditionally attached to an IAM group via aws_iam_group_policy_attachment and to a CI build workflow role via a second aws_iam_role_policy_attachment. Cross-account pull access is handled entirely in outputs.tf, where the ecr_repository_policy output conditionally renders a repository policy JSON granting pull actions to specified account IDs when enable_cross_account_pull is true.

## Features

- Creates aws_iam_role with configurable assume-role principal for application ECR access
- Creates aws_iam_policy granting full ECR repository lifecycle actions including create, delete, push, and pull
- Attaches ECR manager policy to an optional IAM group for CI build workflow users migrating from access keys
- Attaches ECR manager policy to an optional IAM role for CI build workflow role-based authentication
- Generates cross-account ECR repository policy JSON granting pull access to specified AWS account IDs
- Namespaces all IAM resource names using the cluster_name variable to support multi-cluster deployments

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ecr?ref=v9.6.0"

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.70.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_group_policy_attachment.ecr_manager_policy_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.nullplatform_ecr_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.nullplatform_application_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecr_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecr_manager_policy_build_workflow_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [terraform_data.validations](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_manager_assume_role"></a> [application\_manager\_assume\_role](#input\_application\_manager\_assume\_role) | ARN of the IAM role assumed by the application manager | `string` | `"arn:aws:iam::283477532906:role/application_manager"` | no |
| <a name="input_build_workflow_group_name"></a> [build\_workflow\_group\_name](#input\_build\_workflow\_group\_name) | Name of the IAM group (from the ci-build-workflow-user module) to which the ECR manager policy is attached. The build workflow user is a member of this group. Set this, build\_workflow\_role\_name, or both while migrating from access keys to the role. | `string` | `null` | no |
| <a name="input_build_workflow_role_name"></a> [build\_workflow\_role\_name](#input\_build\_workflow\_role\_name) | Name of the IAM role (from the ci-build-workflow-role module) to which the ECR manager policy is attached. Set this, build\_workflow\_group\_name, or both while migrating from access keys to the role. | `string` | `null` | no |
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
  "description": "Provisions IAM roles and policies to enable ECR repository management and cross-account image pull access for nullplatform application clusters",
  "architecture": "The module creates an aws_iam_role (nullplatform application role) with a configurable assume-role policy and an aws_iam_policy granting full ECR repository lifecycle permissions. The ECR policy is attached to the application role via aws_iam_role_policy_attachment, and conditionally attached to an IAM group via aws_iam_group_policy_attachment and to a CI build workflow role via a second aws_iam_role_policy_attachment. Cross-account pull access is handled entirely in outputs.tf, where the ecr_repository_policy output conditionally renders a repository policy JSON granting pull actions to specified account IDs when enable_cross_account_pull is true.",
  "features": [
    "Creates aws_iam_role with configurable assume-role principal for application ECR access",
    "Creates aws_iam_policy granting full ECR repository lifecycle actions including create, delete, push, and pull",
    "Attaches ECR manager policy to an optional IAM group for CI build workflow users migrating from access keys",
    "Attaches ECR manager policy to an optional IAM role for CI build workflow role-based authentication",
    "Generates cross-account ECR repository policy JSON granting pull access to specified AWS account IDs",
    "Namespaces all IAM resource names using the cluster_name variable to support multi-cluster deployments"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster, used to namespace IAM resource names",
      "required": true
    },
    {
      "name": "build_workflow_group_name",
      "description": "Name of the IAM group (from the ci-build-workflow-user module) to which the ECR manager policy is attached. The build workflow user is a member of this group. Set this, build_workflow_role_name, or both while migrating from access keys to the role.",
      "required": false
    },
    {
      "name": "build_workflow_role_name",
      "description": "Name of the IAM role (from the ci-build-workflow-role module) to which the ECR manager policy is attached. Set this, build_workflow_group_name, or both while migrating from access keys to the role.",
      "required": false
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
  "hash": "8772569bcbf4964b3aab20c8c3eeb8ef"
}
END_AI_METADATA -->
