# Module: ecr

## Description

Configures Nullplatform ECR provider integration with AWS IAM authentication for CI/CD workflows and application runtime access

## Architecture

Creates an aws_iam_access_key for build workflow authentication and an aws_iam_role for application runtime permissions. These AWS IAM resources are then referenced in a nullplatform_provider_config resource that configures ECR integration with separate credentials for CI (using access keys) and setup/runtime (using IAM role ARN). The module queries aws_caller_identity and aws_region data sources to populate region-specific configuration, establishing a bridge between Nullplatform's provider configuration system and AWS ECR authentication mechanisms.

## Features

- Creates IAM access key for Nullplatform build workflow CI authentication to ECR
- Provisions IAM role for application runtime ECR access with assumable permissions
- Configures Nullplatform ECR provider with region-specific AWS credentials
- Segments provider configuration by custom dimensions for multi-environment support
- Integrates with external application manager role for cross-account access patterns
- Uses lifecycle ignore_changes on attributes to prevent configuration drift

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v1.53.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_manager_assume_role"></a> [application\_manager\_assume\_role](#input\_application\_manager\_assume\_role) | ARN of the IAM role assumed by the application manager | `string` | `"arn:aws:iam::283477532906:role/application_manager"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions to segment the nullplatform provider config (e.g. by region, environment) | `map(string)` | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures Nullplatform ECR provider integration with AWS IAM authentication for CI/CD workflows and application runtime access",
  "architecture": "Creates an aws_iam_access_key for build workflow authentication and an aws_iam_role for application runtime permissions. These AWS IAM resources are then referenced in a nullplatform_provider_config resource that configures ECR integration with separate credentials for CI (using access keys) and setup/runtime (using IAM role ARN). The module queries aws_caller_identity and aws_region data sources to populate region-specific configuration, establishing a bridge between Nullplatform's provider configuration system and AWS ECR authentication mechanisms.",
  "features": [
    "Creates IAM access key for Nullplatform build workflow CI authentication to ECR",
    "Provisions IAM role for application runtime ECR access with assumable permissions",
    "Configures Nullplatform ECR provider with region-specific AWS credentials",
    "Segments provider configuration by custom dimensions for multi-environment support",
    "Integrates with external application manager role for cross-account access patterns",
    "Uses lifecycle ignore_changes on attributes to prevent configuration drift"
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
    }
  ],
  "outputs": [],
  "hash": "b4e4bc8081e218c616df553881bb751a"
}
END_AI_METADATA -->
