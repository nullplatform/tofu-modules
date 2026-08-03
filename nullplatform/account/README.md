# Module: account

## Description

Creates and manages multiple nullplatform accounts using a map-based configuration with optional repository settings

## Architecture

The module iterates over the `nullplatform_accounts` input map using `for_each` to create one `nullplatform_account` resource per entry. Each resource receives its `name`, `repository_prefix`, `repository_provider`, and `slug` values directly from the corresponding map object. Optional fields default to null unless specified, with `slug` defaulting to `poc-account` when omitted.

## Features

- Creates multiple nullplatform_account resources from a single map variable using for_each iteration
- Supports optional repository prefix and provider configuration per account
- Defaults the slug field to 'poc-account' when not explicitly provided
- Enables independent lifecycle management of each account through map key-based resource addressing

## Basic Usage

```hcl
module "account" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/account?ref=v6.8.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_account.nullplatform_account](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nullplatform_accounts"></a> [nullplatform\_accounts](#input\_nullplatform\_accounts) | A map of nullplatform accounts to create with their configuration settings | <pre>map(object({<br/>    name                = string<br/>    repository_prefix   = optional(string)<br/>    repository_provider = optional(string)<br/>    slug                = optional(string, "poc-account")<br/>  }))</pre> | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "account",
  "description": "Creates and manages multiple nullplatform accounts using a map-based configuration with optional repository settings",
  "architecture": "The module iterates over the `nullplatform_accounts` input map using `for_each` to create one `nullplatform_account` resource per entry. Each resource receives its `name`, `repository_prefix`, `repository_provider`, and `slug` values directly from the corresponding map object. Optional fields default to null unless specified, with `slug` defaulting to `poc-account` when omitted.",
  "features": [
    "Creates multiple nullplatform_account resources from a single map variable using for_each iteration",
    "Supports optional repository prefix and provider configuration per account",
    "Defaults the slug field to 'poc-account' when not explicitly provided",
    "Enables independent lifecycle management of each account through map key-based resource addressing"
  ],
  "inputs": [
    {
      "name": "nullplatform_accounts",
      "description": "A map of nullplatform accounts to create with their configuration settings",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "c0c778247ee53319c633d7d4bb9cef6e"
}
END_AI_METADATA -->
