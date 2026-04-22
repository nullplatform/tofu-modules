# Module: account

## Description

Creates and manages Nullplatform accounts with repository configuration settings

## Architecture

This module creates nullplatform_account resources using a for_each loop over the input map. Each account resource is configured with name, repository prefix, repository provider, and slug attributes. The module takes a map of account objects as input and provisions corresponding nullplatform_account resources, with optional defaults for repository_prefix, repository_provider, and slug fields.

## Features

- Creates multiple Nullplatform accounts from a single map input
- Configures repository prefix for each account with default value 'poc-account'
- Sets repository provider (e.g., GitHub) with default value 'github'
- Assigns custom slugs to accounts with default value 'poc-account'
- Supports dynamic account provisioning via for_each iteration

## Basic Usage

```hcl
module "account" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/account?ref=v1.54.0"

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
| <a name="input_nullplatform_accounts"></a> [nullplatform\_accounts](#input\_nullplatform\_accounts) | A map of nullplatform accounts to create with their configuration settings | <pre>map(object({<br/>    name                = string<br/>    repository_prefix   = optional(string, "poc-account")<br/>    repository_provider = optional(string, "github")<br/>    slug                = optional(string, "poc-account")<br/>  }))</pre> | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "account",
  "description": "Creates and manages Nullplatform accounts with repository configuration settings",
  "architecture": "This module creates nullplatform_account resources using a for_each loop over the input map. Each account resource is configured with name, repository prefix, repository provider, and slug attributes. The module takes a map of account objects as input and provisions corresponding nullplatform_account resources, with optional defaults for repository_prefix, repository_provider, and slug fields.",
  "features": [
    "Creates multiple Nullplatform accounts from a single map input",
    "Configures repository prefix for each account with default value 'poc-account'",
    "Sets repository provider (e.g., GitHub) with default value 'github'",
    "Assigns custom slugs to accounts with default value 'poc-account'",
    "Supports dynamic account provisioning via for_each iteration"
  ],
  "inputs": [
    {
      "name": "nullplatform_accounts",
      "description": "A map of nullplatform accounts to create with their configuration settings",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "2b87820ae1d2b13cad2586ff6803ffdc"
}
END_AI_METADATA -->
