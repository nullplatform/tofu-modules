locals {
  nrn_without_namespace = var.nrn != null ? join(":", slice(split(":", var.nrn), 0, 2)) : null
  nrn_parts             = var.nrn != null ? { for part in split(":", var.nrn) : split("=", part)[0] => split("=", part)[1] } : {}
  nrn_tags = {
    for key in ["organization", "account", "namespace"] : key => local.nrn_parts[key]
    if contains(keys(local.nrn_parts), key)
  }

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
    # Same roles as the agent key minus secrets-reader: the base chart deploys
    # the logs controller and the control plane agent, neither of which reads
    # secrets. Keeping the rest aligned means an install can hand base its own
    # credential without losing a capability the agent key had.
    base = {
      name = "BASE"
      role_slugs = [
        "controlplane:agent",
        "developer",
        "ops",
        "secops",
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

  tags = merge(
    { "managedBy" = "IaC" },
    local.nrn_tags,
    { for tag in var.custom_tags : tag.key => tag.value },
  )
}
