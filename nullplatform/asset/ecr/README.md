# Module: ecr

## Description

Configures a nullplatform ECR provider config resource that wires AWS region, CI/CD build credentials, and an application IAM role into a nullplatform registry integration

## Architecture

The module retrieves the current AWS region via the aws_region data source and passes it into a nullplatform_provider_config resource of type 'ecr'. The resource encodes two attribute blocks as JSON: a 'ci' block containing the region and build workflow IAM access key credentials, and a 'setup' block containing the region and the application IAM role ARN. The lifecycle ignore_changes directive on attributes prevents drift detection from overwriting provider-managed attribute updates after initial creation.

## Features

- Creates a nullplatform ECR provider config resource scoped to a specific NRN
- Configures CI/CD build workflow credentials with AWS access key ID and secret for ECR image publishing
- Configures application-level ECR access using an IAM role ARN for image pulling
- Automatically resolves and injects the current AWS region into both CI and setup attribute blocks
- Supports optional dimension segmentation for multi-region or multi-environment provider config scoping
- Marks build workflow secret access key as sensitive to prevent exposure in Terraform output

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v4.0.0"

  application_role_arn             = "your-application-role-arn"
  build_workflow_access_key_id     = "your-build-workflow-access-key-id"
  build_workflow_access_key_secret = "your-build-workflow-access-key-secret"
  nrn                              = "your-nrn"
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
| [nullplatform_provider_config.ecr](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [terraform_data.validations](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_role_arn"></a> [application\_role\_arn](#input\_application\_role\_arn) | ARN of the IAM role used by applications to pull ECR images | `string` | n/a | yes |
| <a name="input_build_workflow_access_key_id"></a> [build\_workflow\_access\_key\_id](#input\_build\_workflow\_access\_key\_id) | Access key ID for the CI/CD build workflow IAM user | `string` | n/a | yes |
| <a name="input_build_workflow_access_key_secret"></a> [build\_workflow\_access\_key\_secret](#input\_build\_workflow\_access\_key\_secret) | Secret access key for the CI/CD build workflow IAM user | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions to segment the nullplatform provider config (e.g. by region, environment) | `map(string)` | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures a nullplatform ECR provider config resource that wires AWS region, CI/CD build credentials, and an application IAM role into a nullplatform registry integration",
  "architecture": "The module retrieves the current AWS region via the aws_region data source and passes it into a nullplatform_provider_config resource of type 'ecr'. The resource encodes two attribute blocks as JSON: a 'ci' block containing the region and build workflow IAM access key credentials, and a 'setup' block containing the region and the application IAM role ARN. The lifecycle ignore_changes directive on attributes prevents drift detection from overwriting provider-managed attribute updates after initial creation.",
  "features": [
    "Creates a nullplatform ECR provider config resource scoped to a specific NRN",
    "Configures CI/CD build workflow credentials with AWS access key ID and secret for ECR image publishing",
    "Configures application-level ECR access using an IAM role ARN for image pulling",
    "Automatically resolves and injects the current AWS region into both CI and setup attribute blocks",
    "Supports optional dimension segmentation for multi-region or multi-environment provider config scoping",
    "Marks build workflow secret access key as sensitive to prevent exposure in Terraform output"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "The nullplatform resource name (NRN)",
      "required": true
    },
    {
      "name": "application_role_arn",
      "description": "ARN of the IAM role used by applications to pull ECR images",
      "required": true
    },
    {
      "name": "build_workflow_access_key_id",
      "description": "Access key ID for the CI/CD build workflow IAM user",
      "required": true
    },
    {
      "name": "build_workflow_access_key_secret",
      "description": "Secret access key for the CI/CD build workflow IAM user",
      "required": true
    },
    {
      "name": "dimensions",
      "description": "Dimensions to segment the nullplatform provider config (e.g. by region, environment)",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "65f2f22ca359b697be67d2815c2a424a"
}
END_AI_METADATA -->
