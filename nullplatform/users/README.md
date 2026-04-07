# Module: users

## Description

Creates and manages Nullplatform users with their profile information and role-based authorization grants

## Architecture

The module creates nullplatform_user resources from a map of user configurations, then flattens the user-to-role relationships into individual nullplatform_authz_grant resources. Each user can have multiple role assignments, which are expanded through a nested for_each loop that merges all user-role combinations into a single flat map. The authorization grants reference the created user IDs and associate them with role slugs and NRN (Nullplatform Resource Name) identifiers for access control.

## Features

- Creates Nullplatform user accounts with email, first name, and last name attributes
- Supports multiple role assignments per user through a list of role slugs
- Generates individual authorization grants for each user-role combination
- Associates role grants with Nullplatform Resource Names (NRN) for resource-level access control
- Manages user-role relationships through a flattened resource mapping pattern

## Basic Usage

```hcl
module "users" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/users?ref=v1.52.0"

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
| <a name="input_nullplatform_users"></a> [nullplatform\_users](#input\_nullplatform\_users) | Map of nullplatform users to create with their profile information and role assignments | <pre>map(object({<br/>    email      = string<br/>    first_name = string<br/>    last_name  = string<br/>    role_slug  = list(string)<br/>    nrn        = string<br/>  }))</pre> | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "users",
  "description": "Creates and manages Nullplatform users with their profile information and role-based authorization grants",
  "architecture": "The module creates nullplatform_user resources from a map of user configurations, then flattens the user-to-role relationships into individual nullplatform_authz_grant resources. Each user can have multiple role assignments, which are expanded through a nested for_each loop that merges all user-role combinations into a single flat map. The authorization grants reference the created user IDs and associate them with role slugs and NRN (Nullplatform Resource Name) identifiers for access control.",
  "features": [
    "Creates Nullplatform user accounts with email, first name, and last name attributes",
    "Supports multiple role assignments per user through a list of role slugs",
    "Generates individual authorization grants for each user-role combination",
    "Associates role grants with Nullplatform Resource Names (NRN) for resource-level access control",
    "Manages user-role relationships through a flattened resource mapping pattern"
  ],
  "inputs": [
    {
      "name": "nullplatform_users",
      "description": "Map of nullplatform users to create with their profile information and role assignments",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "4ae90811c4ec5e5eedf7feff500c1f44"
}
END_AI_METADATA -->
