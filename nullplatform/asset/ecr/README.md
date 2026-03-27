# Module: ecr

## Description

Configures an ECR provider in Nullplatform with IAM credentials and role ARN for CI and setup workflows

## Architecture

The module creates a nullplatform_provider_config resource of type 'ecr' that stores AWS region, IAM access key, and IAM role ARN as attributes. It uses data sources aws_caller_identity and aws_region to retrieve current AWS account and region information. The IAM access key and role ARN are referenced from externally created AWS resources and injected into the provider configuration attributes under 'ci' and 'setup' sections.

## Features

- Registers ECR provider in Nullplatform with NRN-scoped configuration
- Injects IAM access key and secret for CI authentication
- Attaches IAM role ARN for setup operations

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v1.48.3"

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

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures an ECR provider in Nullplatform with IAM credentials and role ARN for CI and setup workflows",
  "architecture": "The module creates a nullplatform_provider_config resource of type 'ecr' that stores AWS region, IAM access key, and IAM role ARN as attributes. It uses data sources aws_caller_identity and aws_region to retrieve current AWS account and region information. The IAM access key and role ARN are referenced from externally created AWS resources and injected into the provider configuration attributes under 'ci' and 'setup' sections.",
  "features": [
    "Registers ECR provider in Nullplatform with NRN-scoped configuration",
    "Injects IAM access key and secret for CI authentication",
    "Attaches IAM role ARN for setup operations"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "The nullplatform resource name (NRN)",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "Nullplatform API key for authentication",
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
  "hash": "9efedd1c79f12b8f8dfe1fc9390240e6"
}
END_AI_METADATA -->
