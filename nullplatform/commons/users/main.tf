resource "nullplatform_user" "nullplatform_user" {
  for_each = var.nullplatform_users

  email      = each.value.email
  first_name = each.value.first_name
  last_name  = each.value.last_name
}

resource "nullplatform_authz_grant" "nullplatform_user_role" {
  for_each = merge([
    for user_key, user_data in var.nullplatform_users : {
      for role in user_data.role_slug :
      "${user_key}-${role}" => {
        user_id   = nullplatform_user.nullplatform_user[user_key].id
        role_slug = role
        nrn       = user_data.nrn
      }
    }
  ]...)

  user_id   = each.value.user_id
  role_slug = each.value.role_slug
  nrn       = each.value.nrn
}