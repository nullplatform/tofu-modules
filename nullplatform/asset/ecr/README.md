# Module: ecr

## Description

Configures a nullplatform ECR provider by registering AWS region, IAM roles, and optional static credentials as a nullplatform_provider_config resource of type 'ecr'

## Architecture

The module reads the current AWS region via a data.aws_region data source and constructs two local objects: a 'ci' block containing the region plus any combination of build_workflow_role_arn and static access key credentials, and a 'setup' block containing the region, application_role_arn, naming_rule, and repository_policy. These locals are JSON-encoded and passed as attributes to a single nullplatform_provider_config resource of type 'ecr', which registers the ECR provider configuration with the nullplatform control plane under the given NRN.

## Features

- Creates a nullplatform_provider_config resource of type 'ecr' that registers AWS ECR as the container image provider
- Supports OIDC-based CI/CD authentication via an IAM role ARN with ARN format validation
- Supports static AWS access key pair credentials for CI/CD workflows as a migration fallback
- Configures application image pull identity by wiring an IAM role ARN into the 'setup.role_arn' attribute
- Applies a customizable jq-based ECR repository naming convention via the naming_rule variable
- Attaches an optional ECR repository policy JSON to all repositories created by nullplatform

## Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v9.3.0"

  application_role_arn = "your-application-role-arn"
  nrn                  = "your-nrn"
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
| <a name="input_build_workflow_access_key_id"></a> [build\_workflow\_access\_key\_id](#input\_build\_workflow\_access\_key\_id) | Access key ID for the CI/CD build workflow IAM user (maps to 'ci.access\_key'). Optional when build\_workflow\_role\_arn is set; must be given together with build\_workflow\_access\_key\_secret. | `string` | `null` | no |
| <a name="input_build_workflow_access_key_secret"></a> [build\_workflow\_access\_key\_secret](#input\_build\_workflow\_access\_key\_secret) | Secret access key for the CI/CD build workflow IAM user (maps to 'ci.secret\_key'). Optional when build\_workflow\_role\_arn is set; must be given together with build\_workflow\_access\_key\_id. | `string` | `null` | no |
| <a name="input_build_workflow_role_arn"></a> [build\_workflow\_role\_arn](#input\_build\_workflow\_role\_arn) | ARN of the IAM role the CI/CD build workflow assumes to push images (maps to 'ci.role\_arn'). `np asset push` assumes it with the CI runner's OIDC token (GitHub Actions) or its ambient AWS credentials, so the role's trust policy must allow that identity. Set this, a static key pair, or both while migrating: once a role is present the platform ignores the keys. | `string` | `null` | no |
| <a name="input_naming_rule"></a> [naming\_rule](#input\_naming\_rule) | jq expression for ECR repository naming convention. Defaults to the Nullplatform platform default. | `string` | `"\"\\(.namespace.slug)/\\(.application.slug)\""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | ECR repository policy JSON applied to every new repository Nullplatform creates (maps to 'setup.policy'). Leave empty to omit. | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ecr",
  "description": "Configures a nullplatform ECR provider by registering AWS region, IAM roles, and optional static credentials as a nullplatform_provider_config resource of type 'ecr'",
  "architecture": "The module reads the current AWS region via a data.aws_region data source and constructs two local objects: a 'ci' block containing the region plus any combination of build_workflow_role_arn and static access key credentials, and a 'setup' block containing the region, application_role_arn, naming_rule, and repository_policy. These locals are JSON-encoded and passed as attributes to a single nullplatform_provider_config resource of type 'ecr', which registers the ECR provider configuration with the nullplatform control plane under the given NRN.",
  "features": [
    "Creates a nullplatform_provider_config resource of type 'ecr' that registers AWS ECR as the container image provider",
    "Supports OIDC-based CI/CD authentication via an IAM role ARN with ARN format validation",
    "Supports static AWS access key pair credentials for CI/CD workflows as a migration fallback",
    "Configures application image pull identity by wiring an IAM role ARN into the 'setup.role_arn' attribute",
    "Applies a customizable jq-based ECR repository naming convention via the naming_rule variable",
    "Attaches an optional ECR repository policy JSON to all repositories created by nullplatform"
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
      "name": "build_workflow_role_arn",
      "description": "ARN of the IAM role the CI/CD build workflow assumes to push images (maps to 'ci.role_arn'). `np asset push` assumes it with the CI runner's OIDC token (GitHub Actions) or its ambient AWS credentials, so the role's trust policy must allow that identity. Set this, a static key pair, or both while migrating: once a role is present the platform ignores the keys.",
      "required": false
    },
    {
      "name": "build_workflow_access_key_id",
      "description": "Access key ID for the CI/CD build workflow IAM user (maps to 'ci.access_key'). Optional when build_workflow_role_arn is set; must be given together with build_workflow_access_key_secret.",
      "required": false
    },
    {
      "name": "build_workflow_access_key_secret",
      "description": "Secret access key for the CI/CD build workflow IAM user (maps to 'ci.secret_key'). Optional when build_workflow_role_arn is set; must be given together with build_workflow_access_key_id.",
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
  "hash": "c6002130b6a6c698df11a3ca70359702"
}
END_AI_METADATA -->
