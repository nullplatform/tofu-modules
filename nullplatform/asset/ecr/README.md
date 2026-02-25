# Module: ecr

## Description

Configures AWS ECR integration with Nullplatform for container image management and CI/CD workflows

## Features

- Creates IAM role and policy for ECR repository management with restricted access
- Configures IAM user and access keys for build workflow authentication
- Provisions ECR permissions for image push, pull, and repository lifecycle operations
- Integrates AWS ECR with Nullplatform provider for automated container registry setup
- Supports cross-account role assumption for application manager access
- Attaches ECR management policies to both role and user for CI/CD flexibility

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v1.38.0"

  cluster_name = "your-cluster-name"
  np_api_key   = "your-np-api-key"
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
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
<!-- END_TF_DOCS -->
