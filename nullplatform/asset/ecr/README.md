# Module: ecr

## Description

Configures a Nullplatform ECR provider config resource that wires AWS ECR settings, IAM role ARN, and CI/CD credentials into the Nullplatform platform

## Architecture

The module reads the current AWS region via the aws_region data source and combines it with input variables into a single nullplatform_provider_config resource of type 'ecr'. The provider config encodes two attribute blocks: a 'ci' block containing the AWS region and IAM access key credentials for the build workflow, and a 'setup' block containing the region, application IAM role ARN, repository naming rule, and optional repository policy. All values flow directly from input variables into the jsonencode'd attributes of the nullplatform_provider_config resource.

## Features

- Creates a Nullplatform provider config resource of type 'ecr' scoped to a specific NRN
- Configures CI/CD build workflow credentials with AWS access key ID and secret for ECR image pushes
- Wires an application IAM role ARN for ECR image pull access into the provider setup block
- Supports a custom jq-based ECR repository naming convention defaulting to namespace/application slug format
- Accepts an optional ECR repository policy JSON applied to all repositories created by Nullplatform
- Marks the build workflow secret access key as sensitive to prevent exposure in Terraform output

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v6.16.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.44.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |
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
| <a name="input_naming_rule"></a> [naming\_rule](#input\_naming\_rule) | jq expression for ECR repository naming convention. Defaults to the Nullplatform platform default. | `string` | `"\"\\(.namespace.slug)/\\(.application.slug)\""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | ECR repository policy JSON applied to every new repository Nullplatform creates (maps to 'setup.policy'). Leave empty to omit. | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures a Nullplatform ECR provider config resource that wires AWS ECR settings, IAM role ARN, and CI/CD credentials into the Nullplatform platform",
  "architecture": "The module reads the current AWS region via the aws_region data source and combines it with input variables into a single nullplatform_provider_config resource of type 'ecr'. The provider config encodes two attribute blocks: a 'ci' block containing the AWS region and IAM access key credentials for the build workflow, and a 'setup' block containing the region, application IAM role ARN, repository naming rule, and optional repository policy. All values flow directly from input variables into the jsonencode'd attributes of the nullplatform_provider_config resource.",
  "features": [
    "Creates a Nullplatform provider config resource of type 'ecr' scoped to a specific NRN",
    "Configures CI/CD build workflow credentials with AWS access key ID and secret for ECR image pushes",
    "Wires an application IAM role ARN for ECR image pull access into the provider setup block",
    "Supports a custom jq-based ECR repository naming convention defaulting to namespace/application slug format",
    "Accepts an optional ECR repository policy JSON applied to all repositories created by Nullplatform",
    "Marks the build workflow secret access key as sensitive to prevent exposure in Terraform output"
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
    },
    {
      "name": "repository_policy",
      "description": "ECR repository policy JSON applied to every new repository Nullplatform creates (maps to 'setup.policy'). Leave empty to omit.",
      "required": false
    },
    {
      "name": "naming_rule",
      "description": "jq expression for ECR repository naming convention. Defaults to the Nullplatform platform default.",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "7827b03278a4fb2c67ee8cddef95ab04"
}
END_AI_METADATA -->
