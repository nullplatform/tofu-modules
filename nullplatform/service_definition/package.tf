################################################################################
# Package (optional)
#
# Registers this service definition as a versioned package: one revision whose
# bill of materials pins the service specification, every action specification,
# every LINK specification, and the caller's artifacts. Mirrors exactly what
# `np package publish` pins, so Terraform-defined services and CLI-published
# packages are interchangeable.
#
# This is the scope_definition package block plus a link-specification tier:
# services own links (nullplatform_link_specification), so the BOM pins those
# too, hanging off the owning service spec via parent_id — same as actions.
#
# Enabled by setting `var.package` (see variables.tf). Publishing a new
# revision = bump `package.version` (usually together with new artifact metas);
# re-applying the same version with the same components is an idempotent no-op.
################################################################################

locals {
  package_enabled = var.package != null

  # Artifacts split by intent:
  #   create — `meta` given, lookup=false: register a new revision here
  #   lookup — `meta` given, lookup=true: resolve an existing artifact by identity
  #   pinned — explicit resource ids, taken as-is
  package_artifacts_to_create = local.package_enabled ? {
    for a in var.package.artifacts : a.name => a if a.meta != null && !a.lookup
  } : {}

  package_artifacts_to_lookup = local.package_enabled ? {
    for a in var.package.artifacts : a.name => a if a.meta != null && a.lookup
  } : {}

  package_artifacts_existing = local.package_enabled ? {
    for a in var.package.artifacts : a.name => a if a.meta == null
  } : {}

  package_visible_to = local.package_enabled ? coalesce(var.package.visible_to, [var.nrn]) : []

  # ── Default-created actions (use_default_actions = true) ────────────────────
  # When a spec uses default actions, the platform creates them server-side —
  # they are NOT nullplatform_action_specification resources, so the explicit
  # `from_templates` block below never sees them. The provider exposes them via
  # the spec's computed `action_specifications`; expand those into the BOM so a
  # service that relies on default actions still pins them (this is what the
  # standalone packaged_service module does).
  #
  # NOTE: these are known only once the spec exists (server-side ids/snapshots).
  # On a first apply that CREATES the spec they are not yet known, so pin them on
  # a subsequent apply (or create specs first, then package) — same two-step the
  # packaged_service module formalizes.

  # Explicit actions (from available_actions) win over the same action arriving
  # through a spec's default expansion — its name/parent are author-chosen and
  # stable from the first apply.
  package_explicit_action_ids = local.package_enabled ? toset([
    for r in nullplatform_action_specification.from_templates : r.id
  ]) : toset([])

  # Default actions on the SERVICE spec, keyed by slug (unique within the spec).
  package_service_default_actions = local.package_enabled ? {
    for a in nullplatform_service_specification.from_template.action_specifications :
    a.slug => { id = a.id, snap = a.last_snapshot_id, parent = nullplatform_service_specification.from_template.id }
    if try(a.last_snapshot_id, "") != "" && !contains(local.package_explicit_action_ids, a.id)
  } : {}

  # Default actions on EACH link, name-spaced by link key so slugs never clash
  # across links (or with the service's own actions). parent = the link's id.
  package_link_default_actions = local.package_enabled ? merge([
    for lk, lr in nullplatform_link_specification.from_templates : {
      for a in lr.action_specifications :
      "${lk}/${a.slug}" => { id = a.id, snap = a.last_snapshot_id, parent = lr.id }
      if try(a.last_snapshot_id, "") != "" && !contains(local.package_explicit_action_ids, a.id)
    }
  ]...) : {}

  package_default_actions = merge(local.package_service_default_actions, local.package_link_default_actions)
}

# New artifact revisions declared inline on the package.
resource "nullplatform_artifact" "package" {
  for_each = local.package_artifacts_to_create

  nrn        = var.nrn
  type       = each.value.type
  meta       = jsonencode(each.value.meta)
  visible_to = local.package_visible_to
}

# Existing artifacts resolved by identity — no ids in your configuration.
# Identity meta (e.g. registry+repository for oci_image, or url for
# git_repository) selects the artifact; include the type's own per-revision
# field to pin a revision — digest ("sha256:<64-hex>") for oci_image,
# reference (e.g. a tag) for git_repository; the API rejects the other
# type's field name — else latest wins.
data "nullplatform_artifact" "package" {
  for_each = local.package_artifacts_to_lookup

  nrn  = var.nrn
  type = each.value.type
  meta = jsonencode(each.value.meta)
}

resource "nullplatform_package" "this" {
  count = local.package_enabled ? 1 : 0

  nrn        = var.nrn
  slug       = coalesce(var.package.slug, nullplatform_service_specification.from_template.slug)
  name       = coalesce(var.package.name, var.service_name)
  version    = var.package.version
  default    = var.package.default
  tags       = var.package.tags
  visible_to = local.package_visible_to

  # The service specification — the CLI publishes this component as "service".
  components {
    name                 = "service"
    resource_type        = "service_specification"
    resource_id          = nullplatform_service_specification.from_template.id
    resource_revision_id = nullplatform_service_specification.from_template.last_snapshot_id
  }

  # Every action specification, hanging off its owning spec via parent_id.
  # for_each over a map iterates in lexical key order, so the BOM stays stable.
  dynamic "components" {
    for_each = nullplatform_action_specification.from_templates
    content {
      name                 = components.key
      resource_type        = "action_specification"
      resource_id          = components.value.id
      resource_revision_id = components.value.last_snapshot_id
      parent_id            = nullplatform_service_specification.from_template.id
    }
  }

  # Default-created action specifications (use_default_actions), expanded from the
  # service spec's and each link's computed action_specifications. Only pins
  # actions that already have a snapshot (known once the spec exists) — see the
  # two-step note in locals above.
  dynamic "components" {
    for_each = local.package_default_actions
    content {
      name                 = components.key
      resource_type        = "action_specification"
      resource_id          = components.value.id
      resource_revision_id = components.value.snap
      parent_id            = components.value.parent
    }
  }

  # Every link specification, likewise parented to the owning service spec.
  # This is the service-specific tier the scope package doesn't have.
  dynamic "components" {
    for_each = nullplatform_link_specification.from_templates
    content {
      name                 = components.key
      resource_type        = "link_specification"
      resource_id          = components.value.id
      resource_revision_id = components.value.last_snapshot_id
      parent_id            = nullplatform_service_specification.from_template.id
    }
  }

  # Artifacts registered by this module.
  dynamic "components" {
    for_each = nullplatform_artifact.package
    content {
      name                 = components.key
      resource_type        = "artifact"
      resource_id          = components.value.artifact_id
      resource_revision_id = components.value.id
    }
  }

  # Artifacts resolved by identity lookup.
  dynamic "components" {
    for_each = data.nullplatform_artifact.package
    content {
      name                 = components.key
      resource_type        = "artifact"
      resource_id          = components.value.artifact_id
      resource_revision_id = components.value.revision_id
    }
  }

  # Artifacts registered elsewhere, pinned as-is.
  dynamic "components" {
    for_each = local.package_artifacts_existing
    content {
      name                 = components.key
      resource_type        = "artifact"
      resource_id          = components.value.resource_id
      resource_revision_id = components.value.resource_revision_id
    }
  }
}
