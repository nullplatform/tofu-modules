# Module: users

## Description

Manages nullplatform users and their authorization grants with role-based access control

## Features

- Creates nullplatform users with profile information including email, first name, and last name
- Manages authorization grants for users with role-based access control
- Supports multiple role assignments per user through role slug configuration
- Implements resource-based permissions using nullplatform resource names (NRN)
- Enables dynamic user and role management through map-based configuration
- Provides secure API key authentication for nullplatform provider

## Basic Usage

```hcl
module "users" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/users?ref=v1.38.2"

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
