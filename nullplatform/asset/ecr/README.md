# Module: ecr

## Description

Configures Nullplatform provider with AWS ECR integration using IAM credentials for CI/CD workflows and EKS application deployment

## Architecture

Creates a nullplatform_provider_config resource that references aws_iam_access_key for CI/CD authentication and aws_iam_role for application runtime. Data sources aws_caller_identity and aws_region retrieve current AWS context. The provider config encodes IAM credentials and role ARN into a JSON attributes structure, establishing trust between Nullplatform and AWS ECR for container image management.

## Features

- Creates IAM access keys for Nullplatform build workflow authentication to ECR
- Configures IAM role for Nullplatform application runtime with ECR pull permissions
- Establishes Nullplatform provider configuration with regional ECR endpoints
- Encodes AWS credentials and role ARN in JSON format for Nullplatform consumption
- Ignores lifecycle changes to attributes to prevent configuration drift

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v1.52.3"

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
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures Nullplatform provider with AWS ECR integration using IAM credentials for CI/CD workflows and EKS application deployment",
  "architecture": "Creates a nullplatform_provider_config resource that references aws_iam_access_key for CI/CD authentication and aws_iam_role for application runtime. Data sources aws_caller_identity and aws_region retrieve current AWS context. The provider config encodes IAM credentials and role ARN into a JSON attributes structure, establishing trust between Nullplatform and AWS ECR for container image management.",
  "features": [
    "Creates IAM access keys for Nullplatform build workflow authentication to ECR",
    "Configures IAM role for Nullplatform application runtime with ECR pull permissions",
    "Establishes Nullplatform provider configuration with regional ECR endpoints",
    "Encodes AWS credentials and role ARN in JSON format for Nullplatform consumption",
    "Ignores lifecycle changes to attributes to prevent configuration drift"
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
    }
  ],
  "outputs": [],
  "hash": "67a1b139f3d9a964db7055ef1475676d"
}
END_AI_METADATA -->
