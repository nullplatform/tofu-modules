# Module: Account

Creates Nullplatform accounts from the provided map, configuring repository prefixes, providers, and slugs for each entry.

Usage:


```
module "account" {
  source                = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/account?ref=v1.0.0"
  nullplatform_accounts = var.nullplatform_accounts
  np_api_key            = var.np_api_key
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
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | The API token must be at the organization level | `string` | n/a | yes |
| <a name="input_nullplatform_accounts"></a> [nullplatform\_accounts](#input\_nullplatform\_accounts) | Map of Nullplatform accounts to create with their configuration settings | <pre>map(object({<br/>    name                = string<br/>    repository_prefix   = optional(string, "poc-account")<br/>    repository_provider = optional(string, "github")<br/>    slug                = optional(string, "poc-account")<br/>  }))</pre> | n/a | yes |
<!-- END_TF_DOCS -->
