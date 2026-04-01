locals {
  nrn_without_namespace = var.nrn != null ? join(":", slice(split(":", var.nrn), 0, 2)) : null
  nrn_parts             = var.nrn != null ? { for part in split(":", var.nrn) : split("=", part)[0] => split("=", part)[1] } : {}
  nrn_tags = [
    for key in ["organization", "account", "namespace"] : {
      key   = key
      value = local.nrn_parts[key]
    } if contains(keys(local.nrn_parts), key)
  ]

  slug = var.specification_slug != null ? upper(var.specification_slug) : ""

  configs = {
    agent = {
      name = "AGENT"
      role_slugs = [
        "controlplane:agent",
        "developer",
        "ops",
        "secops",
        "secrets-reader",
      ]
    }
    scope_notification = {
      name = "SCOPE-NOTIFICATION-CHANNEL-${local.slug}"
      role_slugs = [
        "controlplane:agent",
        "ops",
      ]
    }
    service_notification = {
      name = "SERVICE-NOTIFICATION-CHANNEL-${local.slug}"
      role_slugs = [
        "controlplane:agent",
        "admin",
        "ops",
      ]
    }
    custom = {
      name       = var.custom_name != null ? var.custom_name : ""
      role_slugs = var.custom_role_slugs
    }
  }

  config = local.configs[var.type]

  grants = length(var.custom_grants) > 0 ? var.custom_grants : [
    for slug in local.config.role_slugs : {
      nrn       = local.nrn_without_namespace
      role_slug = slug
    }
  ]

  tags = concat(
    [{ key = "managedBy", value = "IaC" }],
    local.nrn_tags,
    var.custom_tags,
  )
}
