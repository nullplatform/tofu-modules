# Module: users

## Description

Manages Nullplatform users and their role-based authorization grants

## Features

- Creates Nullplatform users with profile information including email, first name, and last name
- Assigns multiple role-based authorization grants to users
- Supports flexible role assignment through user-role mappings
- Manages authorization grants using Nullplatform Resource Names (NRNs)
- Handles multiple users through map-based configuration
- Configures Nullplatform provider authentication with API key

## Basic Usage

```hcl
module "users" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/users?ref=v1.38.3"

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
