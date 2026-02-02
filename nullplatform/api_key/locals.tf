locals {
  nrn_without_namespace = join(":", slice(split(":", var.nrn), 0, 2))
  nrn_parts             = { for part in split(":", var.nrn) : split("=", part)[0] => split("=", part)[1] }
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

  grants = [
    for slug in local.config.role_slugs : {
      nrn       = local.nrn_without_namespace
      role_slug = slug
    }
  ]

  used_by_tag = var.specification_slug != null && var.type != "custom" ? [
    { key = "usedBy", value = upper(var.specification_slug) }
  ] : []

  tags = concat(
    [{ key = "managedBy", value = "IaC" }],
    local.used_by_tag,
    local.nrn_tags,
    var.custom_tags,
  )
}
