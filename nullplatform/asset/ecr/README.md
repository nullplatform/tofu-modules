# Module: ecr

## Description

Configures an AWS ECR provider integration for nullplatform by creating IAM users, roles, access keys, and optional cross-account repository policies

## Architecture

The module creates an aws_iam_access_key for a build workflow IAM user and an aws_iam_role for application workloads, then wires their credentials and ARN into a nullplatform_provider_config resource of type 'ecr'. The provider config encodes both CI credentials (region, access key, secret key) and setup attributes (region, role ARN) as JSON attributes. When cross-account pull is enabled, a repository policy is generated in locals and merged into the setup attributes, allowing specified AWS account IDs to pull images from ECR.

## Features

- Creates nullplatform_provider_config of type ECR linking CI and setup credentials
- Configures IAM access keys for build workflow automation with ECR push permissions
- Creates IAM role for application workloads to pull images from ECR
- Generates ECR repository policy allowing cross-account image pulls when enabled
- Supports multiple additional AWS account IDs for cross-account ECR pull access
- Supports dimension-based segmentation of the nullplatform provider config by region or environment

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v3.2.0"

  cluster_name = "your-cluster-name"
  nrn          = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.ecr.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.88 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.44.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.88 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.nullplatform_build_workflow_user_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.nullplatform_ecr_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.nullplatform_application_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecr_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.nullplatform_build_workflow_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.ecr_manager_policy_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [nullplatform_provider_config.ecr](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [terraform_data.validations](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_manager_assume_role"></a> [application\_manager\_assume\_role](#input\_application\_manager\_assume\_role) | ARN of the IAM role assumed by the application manager | `string` | `"arn:aws:iam::283477532906:role/application_manager"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions to segment the nullplatform provider config (e.g. by region, environment) | `map(string)` | `{}` | no |
| <a name="input_enable_cross_account_pull"></a> [enable\_cross\_account\_pull](#input\_enable\_cross\_account\_pull) | Enable cross-account ECR pull access via a repository policy | `bool` | `false` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
| <a name="input_repository_policy_pull_accounts"></a> [repository\_policy\_pull\_accounts](#input\_repository\_policy\_pull\_accounts) | AWS account IDs allowed to pull images from ECR. The account where this module is deployed is always included. | `list(string)` | `[]` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures an AWS ECR provider integration for nullplatform by creating IAM users, roles, access keys, and optional cross-account repository policies",
  "architecture": "The module creates an aws_iam_access_key for a build workflow IAM user and an aws_iam_role for application workloads, then wires their credentials and ARN into a nullplatform_provider_config resource of type 'ecr'. The provider config encodes both CI credentials (region, access key, secret key) and setup attributes (region, role ARN) as JSON attributes. When cross-account pull is enabled, a repository policy is generated in locals and merged into the setup attributes, allowing specified AWS account IDs to pull images from ECR.",
  "features": [
    "Creates nullplatform_provider_config of type ECR linking CI and setup credentials",
    "Configures IAM access keys for build workflow automation with ECR push permissions",
    "Creates IAM role for application workloads to pull images from ECR",
    "Generates ECR repository policy allowing cross-account image pulls when enabled",
    "Supports multiple additional AWS account IDs for cross-account ECR pull access",
    "Supports dimension-based segmentation of the nullplatform provider config by region or environment"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "The nullplatform resource name (NRN)",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "Name of the cluster where the policy runs",
      "required": true
    },
    {
      "name": "application_manager_assume_role",
      "description": "ARN of the IAM role assumed by the application manager",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Dimensions to segment the nullplatform provider config (e.g. by region, environment)",
      "required": false
    },
    {
      "name": "enable_cross_account_pull",
      "description": "Enable cross-account ECR pull access via a repository policy",
      "required": false
    },
    {
      "name": "repository_policy_pull_accounts",
      "description": "AWS account IDs allowed to pull images from ECR. The account where this module is deployed is always included.",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "dfc7c1cda7f15d57bce971b0129fec6a"
}
END_AI_METADATA -->
