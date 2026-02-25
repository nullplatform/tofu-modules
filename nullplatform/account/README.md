# Module: account

## Description

Creates and manages Nullplatform accounts with configurable repository settings

## Features

- Creates multiple Nullplatform accounts from a map configuration
- Configures repository prefix and provider for each account
- Supports custom slug generation for account identification
- Manages accounts using the Nullplatform provider
- Provides default values for repository settings

## Basic Usage

```hcl
module "account" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/account?ref=v1.36.0"

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
