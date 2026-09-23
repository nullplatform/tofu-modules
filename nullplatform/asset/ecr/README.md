# Module: ecr

## Description

Configures a Nullplatform ECR provider by registering AWS region, IAM role, CI/CD credentials, and repository settings as a nullplatform_provider_config resource

## Architecture

The module reads the current AWS region via the aws_region data source and combines it with input variables into a local setup map. A single nullplatform_provider_config resource of type 'ecr' is created, embedding CI credentials (access key ID and secret) alongside the setup block containing region, IAM role ARN, naming rule, and repository policy as a JSON-encoded attributes payload. The nrn variable scopes the provider config to a specific Nullplatform resource, and sensitive credentials are passed directly into the resource without additional wrapping.

## Features

- Creates a nullplatform_provider_config resource of type ECR to register the container registry provider
- Embeds CI/CD build workflow IAM credentials (access key ID and secret) for pipeline image push access
- Configures an IAM role ARN for application-level ECR image pull authorization
- Supports a customizable jq-based ECR repository naming convention via the naming_rule variable
- Accepts an optional ECR repository policy JSON applied to all repositories created by Nullplatform
- Automatically resolves and injects the current AWS region from the aws_region data source

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v8.0.0"

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
| <a name="input_naming_rule"></a> [naming\_rule](#input\_naming\_rule) | jq expression for ECR repository naming convention. Defaults to the Nullplatform platform default. | `string` | `"\"\\(.namespace.slug)/\\(.application.slug)\""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | ECR repository policy JSON applied to every new repository Nullplatform creates (maps to 'setup.policy'). Leave empty to omit. | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures a Nullplatform ECR provider by registering AWS region, IAM role, CI/CD credentials, and repository settings as a nullplatform_provider_config resource",
  "architecture": "The module reads the current AWS region via the aws_region data source and combines it with input variables into a local setup map. A single nullplatform_provider_config resource of type 'ecr' is created, embedding CI credentials (access key ID and secret) alongside the setup block containing region, IAM role ARN, naming rule, and repository policy as a JSON-encoded attributes payload. The nrn variable scopes the provider config to a specific Nullplatform resource, and sensitive credentials are passed directly into the resource without additional wrapping.",
  "features": [
    "Creates a nullplatform_provider_config resource of type ECR to register the container registry provider",
    "Embeds CI/CD build workflow IAM credentials (access key ID and secret) for pipeline image push access",
    "Configures an IAM role ARN for application-level ECR image pull authorization",
    "Supports a customizable jq-based ECR repository naming convention via the naming_rule variable",
    "Accepts an optional ECR repository policy JSON applied to all repositories created by Nullplatform",
    "Automatically resolves and injects the current AWS region from the aws_region data source"
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
  "hash": "b06773a03ffc4f4f5035528345edaa98"
}
END_AI_METADATA -->
