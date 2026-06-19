# Module: ecr

## Description

Configures a nullplatform ECR provider config resource with CI/CD credentials, application role, and optional cross-account pull access

## Architecture

The module reads the current AWS region via the aws_region data source and uses it alongside input variables to construct a nullplatform_provider_config resource of type 'ecr'. The provider config encodes a JSON attributes blob containing a 'ci' section with build workflow IAM credentials, a 'setup' section with the application role ARN and repository naming rule, and conditionally a 'setup.policy' field when a repository policy is supplied. When a cross-account pull role ARN is provided, an additional 'read' section is merged into the attributes to enable cross-account ECR image pulling.

## Features

- Creates a nullplatform ECR provider config resource with structured CI and setup attribute sections
- Configures CI/CD build workflow credentials using an IAM access key ID and secret for ECR push access
- Configures application IAM role ARN for ECR image pull in the setup section
- Supports optional cross-account ECR pull access by conditionally including a read section with a separate IAM role ARN
- Supports optional ECR repository policy JSON applied to all repositories created by nullplatform
- Allows customizable ECR repository naming conventions via a configurable jq expression

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v4.5.1"

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
| <a name="input_naming_rule"></a> [naming\_rule](#input\_naming\_rule) | jq expression for ECR repository naming convention. Defaults to the Nullplatform platform default. | `string` | `"\"\\(.namespace.slug)/\\(.application.slug)\""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | ECR repository policy JSON applied to every new repository Nullplatform creates (maps to 'setup.policy'). Leave empty to omit. | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures a nullplatform ECR provider config resource with CI/CD credentials, application role, and optional cross-account pull access",
  "architecture": "The module reads the current AWS region via the aws_region data source and uses it alongside input variables to construct a nullplatform_provider_config resource of type 'ecr'. The provider config encodes a JSON attributes blob containing a 'ci' section with build workflow IAM credentials, a 'setup' section with the application role ARN and repository naming rule, and conditionally a 'setup.policy' field when a repository policy is supplied. When a cross-account pull role ARN is provided, an additional 'read' section is merged into the attributes to enable cross-account ECR image pulling.",
  "features": [
    "Creates a nullplatform ECR provider config resource with structured CI and setup attribute sections",
    "Configures CI/CD build workflow credentials using an IAM access key ID and secret for ECR push access",
    "Configures application IAM role ARN for ECR image pull in the setup section",
    "Supports optional cross-account ECR pull access by conditionally including a read section with a separate IAM role ARN",
    "Supports optional ECR repository policy JSON applied to all repositories created by nullplatform",
    "Allows customizable ECR repository naming conventions via a configurable jq expression"
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
      "name": "cross_account_pull_role_arn",
      "description": "ARN of the IAM role for cross-account ECR pull access (maps to 'read.role_arn' in provider config). Leave empty to omit the read section.",
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
  "hash": "5a7b0f106ac62a1742993b8d7f3cc494"
}
END_AI_METADATA -->
