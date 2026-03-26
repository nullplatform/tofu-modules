# Module: account

## Description

This module creates and configures nullplatform accounts with their respective repository settings

## Architecture

The module utilizes the nullplatform_account Terraform resource to create accounts based on the provided nullplatform_accounts variable, which is a map of account configurations. Each account is created with its specified name, repository prefix, repository provider, and slug. The nullplatform API key is used for authentication. The module does not create any other Terraform resources, such as aws_iam_role or helm_release, and instead focuses solely on nullplatform account management. The inputs from the nullplatform_accounts variable flow directly into the nullplatform_account resource, and the np_api_key is used for authentication purposes.

## Features

- Creates nullplatform accounts with custom repository settings
- Configures nullplatform account repository providers
- Supports multiple nullplatform accounts with unique configurations

## Basic Usage

```hcl
module "account" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/account?ref=v1.47.0"

  np_api_key            = "your-np-api-key"
  nullplatform_accounts = "your-nullplatform-accounts"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.account.id
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
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_account.nullplatform_account](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | The nullplatform API key (must be at the organization level) | `string` | n/a | yes |
| <a name="input_nullplatform_accounts"></a> [nullplatform\_accounts](#input\_nullplatform\_accounts) | A map of nullplatform accounts to create with their configuration settings | <pre>map(object({<br/>    name                = string<br/>    repository_prefix   = optional(string, "poc-account")<br/>    repository_provider = optional(string, "github")<br/>    slug                = optional(string, "poc-account")<br/>  }))</pre> | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "account",
  "description": "This module creates and configures nullplatform accounts with their respective repository settings",
  "architecture": "The module utilizes the nullplatform_account Terraform resource to create accounts based on the provided nullplatform_accounts variable, which is a map of account configurations. Each account is created with its specified name, repository prefix, repository provider, and slug. The nullplatform API key is used for authentication. The module does not create any other Terraform resources, such as aws_iam_role or helm_release, and instead focuses solely on nullplatform account management. The inputs from the nullplatform_accounts variable flow directly into the nullplatform_account resource, and the np_api_key is used for authentication purposes.",
  "features": [
    "Creates nullplatform accounts with custom repository settings",
    "Configures nullplatform account repository providers",
    "Supports multiple nullplatform accounts with unique configurations"
  ],
  "inputs": [
    {
      "name": "nullplatform_accounts",
      "description": "A map of nullplatform accounts to create with their configuration settings",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "The nullplatform API key (must be at the organization level)",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "04efc79bccf80b8ccc57aba50b9e0ba8"
}
END_AI_METADATA -->
