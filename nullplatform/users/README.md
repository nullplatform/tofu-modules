# Module: users

## Description

Creates Nullplatform users and assigns them roles through authorization grants

## Architecture

The module loops over var.nullplatform_users to create nullplatform_user resources, then flattens the user-role pairs into nullplatform_authz_grant resources that bind each user to their specified roles on the given NRN. The np_api_key authenticates all provider operations. Outputs expose the generated user IDs.

## Features

- Creates multiple Nullplatform users with email, first name, and last name
- Assigns each user one or more role slugs via authorization grants
- Supports per-user NRN scoping for fine-grained permissions

## Basic Usage

```hcl
module "users" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/users?ref=v1.46.0"

  np_api_key         = "your-np-api-key"
  nullplatform_users = "your-nullplatform-users"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.users.id
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
| [nullplatform_authz_grant.nullplatform_user_role](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/authz_grant) | resource |
| [nullplatform_user.nullplatform_user](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nullplatform_users"></a> [nullplatform\_users](#input\_nullplatform\_users) | Map of nullplatform users to create with their profile information and role assignments | <pre>map(object({<br/>    email      = string<br/>    first_name = string<br/>    last_name  = string<br/>    role_slug  = list(string)<br/>    nrn        = string<br/>  }))</pre> | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "users",
  "description": "Creates Nullplatform users and assigns them roles through authorization grants",
  "architecture": "The module loops over var.nullplatform_users to create nullplatform_user resources, then flattens the user-role pairs into nullplatform_authz_grant resources that bind each user to their specified roles on the given NRN. The np_api_key authenticates all provider operations. Outputs expose the generated user IDs.",
  "features": [
    "Creates multiple Nullplatform users with email, first name, and last name",
    "Assigns each user one or more role slugs via authorization grants",
    "Supports per-user NRN scoping for fine-grained permissions"
  ],
  "inputs": [
    {
      "name": "nullplatform_users",
      "description": "Map of nullplatform users to create with their profile information and role assignments",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "Nullplatform API key for authentication",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "6863fdf400c277edc8848d4b93db156f"
}
END_AI_METADATA -->
