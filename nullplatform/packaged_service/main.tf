################################################################################
# packaged_service
#
# Turns a service_specification (+ optional link_specification) into a versioned
# nullplatform PACKAGE: one revision whose bill of materials pins the service
# spec, the link spec, every default-created action of both, and the caller's
# artifacts — each frozen to an exact snapshot. Mirrors what the CLI publishes,
# so Terraform-defined and CLI-published service packages are interchangeable.
################################################################################

locals {
  svc = var.service_specification
  lnk = var.link_specification

  # `alias.default` is the package's default version; absent → the version we
  # publish. (Other alias keys are reserved for a later revision → package tags.)
  default_version = coalesce(try(var.alias["default"], null), var.package_version)

  visible_to = coalesce(var.visible_to, try(local.svc.visible_to, null), [var.nrn])

  # Artifacts split by intent (same partitioning as scope_definition/package.tf):
  #   create — `meta`, lookup=false: register a new revision here
  #   lookup — `meta`, lookup=true:  resolve an existing artifact by identity
  #   pinned — explicit ids:         taken as-is
  artifacts_to_create = { for a in var.artifacts : a.name => a if a.meta != null && !a.lookup }
  artifacts_to_lookup = { for a in var.artifacts : a.name => a if a.meta != null && a.lookup }
  artifacts_existing  = { for a in var.artifacts : a.name => a if a.meta == null }

  # Default-created action specs of each spec, keyed by slug for a stable BOM.
  # Only actions that already have a snapshot can be pinned — skip any without
  # one (e.g. an old action predating snapshots) rather than sending an empty
  # resource_revision_id the package API would reject.
  svc_actions = { for a in try(local.svc.action_specifications, []) : a.slug => a if try(a.last_snapshot_id, "") != "" }
  lnk_actions = local.lnk == null ? {} : { for a in try(local.lnk.action_specifications, []) : a.slug => a if try(a.last_snapshot_id, "") != "" }
}

# New artifact revisions declared inline on the package.
resource "nullplatform_artifact" "this" {
  for_each = local.artifacts_to_create

  nrn        = var.nrn
  type       = each.value.type
  meta       = jsonencode(each.value.meta)
  visible_to = local.visible_to
}

# Existing artifacts resolved by identity — no ids in configuration.
data "nullplatform_artifact" "this" {
  for_each = local.artifacts_to_lookup

  nrn  = var.nrn
  type = each.value.type
  meta = jsonencode(each.value.meta)
}

resource "nullplatform_package" "this" {
  nrn             = var.nrn
  slug            = coalesce(var.slug, try(local.svc.slug, null))
  name            = coalesce(var.name, try(local.svc.name, null))
  version         = var.package_version
  default_version = local.default_version
  tags            = var.tags
  visible_to      = local.visible_to

  # A component can only be pinned to an existing snapshot. The service spec
  # (BOM root) and the link spec — if given — are mandatory, so fail clearly
  # when they have no snapshot yet instead of publishing a broken revision.
  # (Saving/updating a spec once creates its first snapshot.)
  lifecycle {
    precondition {
      condition     = try(local.svc.last_snapshot_id, "") != ""
      error_message = "service_specification has no snapshot yet (last_snapshot_id is empty). Save/update the service specification once so a snapshot exists, then package it."
    }
    precondition {
      condition     = local.lnk == null || try(local.lnk.last_snapshot_id, "") != ""
      error_message = "link_specification has no snapshot yet (last_snapshot_id is empty). Save/update the link specification once so a snapshot exists, then package it."
    }
  }

  # Service specification — root of the bill of materials.
  components {
    name                 = "service"
    resource_type        = "service_specification"
    resource_id          = local.svc.id
    resource_revision_id = local.svc.last_snapshot_id
  }

  # Service default actions (child of the service spec).
  dynamic "components" {
    for_each = local.svc_actions
    content {
      name                 = "service-action-${components.key}"
      resource_type        = "action_specification"
      resource_id          = components.value.id
      resource_revision_id = components.value.last_snapshot_id
      parent_id            = local.svc.id
    }
  }

  # Link specification (child of the service spec) — only when a link is given.
  dynamic "components" {
    for_each = local.lnk == null ? {} : { link = local.lnk }
    content {
      name                 = "link"
      resource_type        = "link_specification"
      resource_id          = components.value.id
      resource_revision_id = components.value.last_snapshot_id
      parent_id            = local.svc.id
    }
  }

  # Link default actions (child of the link spec).
  dynamic "components" {
    for_each = local.lnk_actions
    content {
      name                 = "link-action-${components.key}"
      resource_type        = "action_specification"
      resource_id          = components.value.id
      resource_revision_id = components.value.last_snapshot_id
      parent_id            = local.lnk.id
    }
  }

  # Artifacts registered by this module.
  dynamic "components" {
    for_each = nullplatform_artifact.this
    content {
      name                 = components.key
      resource_type        = "artifact"
      resource_id          = components.value.artifact_id
      resource_revision_id = components.value.id
    }
  }

  # Artifacts resolved by identity lookup.
  dynamic "components" {
    for_each = data.nullplatform_artifact.this
    content {
      name                 = components.key
      resource_type        = "artifact"
      resource_id          = components.value.artifact_id
      resource_revision_id = components.value.revision_id
    }
  }

  # Artifacts registered elsewhere, pinned as-is.
  dynamic "components" {
    for_each = local.artifacts_existing
    content {
      name                 = components.key
      resource_type        = "artifact"
      resource_id          = components.value.resource_id
      resource_revision_id = components.value.resource_revision_id
    }
  }
}
