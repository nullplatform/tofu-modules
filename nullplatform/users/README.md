# Module: users

## Description

Creates and manages NullPlatform users with profile information and role-based authorization grants

## Architecture

The module iterates over a map of user definitions using `nullplatform_user` resources created with `for_each` to provision each user's profile including email, first name, and last name. A flattened merge of role assignments is then computed to drive `nullplatform_authz_grant` resources, linking each user ID to one or more role slugs and NRN scopes. The authorization grants reference the IDs output by the user resources, establishing an implicit dependency between the two resource types.

## Features

- Creates nullplatform_user resources for each entry in the users map with email, first name, and last name
- Validates email addresses against a standard RFC-style regex pattern before provisioning
- Enforces that each user has at least one role_slug assigned
- Creates nullplatform_authz_grant resources for every user-role combination using a flattened merge
- Supports multiple role assignments per user by expanding role_slug lists into individual grant resources
- Scopes authorization grants to specific NRN (NullPlatform Resource Name) values per user

## Basic Usage

```hcl
module "users" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/users?ref=v7.0.1"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

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
  "description": "Creates and manages NullPlatform users with profile information and role-based authorization grants",
  "architecture": "The module iterates over a map of user definitions using `nullplatform_user` resources created with `for_each` to provision each user's profile including email, first name, and last name. A flattened merge of role assignments is then computed to drive `nullplatform_authz_grant` resources, linking each user ID to one or more role slugs and NRN scopes. The authorization grants reference the IDs output by the user resources, establishing an implicit dependency between the two resource types.",
  "features": [
    "Creates nullplatform_user resources for each entry in the users map with email, first name, and last name",
    "Validates email addresses against a standard RFC-style regex pattern before provisioning",
    "Enforces that each user has at least one role_slug assigned",
    "Creates nullplatform_authz_grant resources for every user-role combination using a flattened merge",
    "Supports multiple role assignments per user by expanding role_slug lists into individual grant resources",
    "Scopes authorization grants to specific NRN (NullPlatform Resource Name) values per user"
  ],
  "inputs": [
    {
      "name": "nullplatform_users",
      "description": "Map of nullplatform users to create with their profile information and role assignments",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "bb0a7d042bbd373cf31af2f9f008f786"
}
END_AI_METADATA -->
