################################################################################
# packaged_service
#
# Turns a service specification (+ its links + artifacts) into a versioned
# nullplatform PACKAGE. You describe the bill of materials as ONE flat
# `components` list that mirrors nullplatform_package.components 1:1; the module
# pins every entry to an exact snapshot and expands each spec's default actions
# as children. Mirrors what the CLI publishes, so Terraform-defined and
# CLI-published service packages are interchangeable.
################################################################################

locals {
  # The single service_specification is the BOM root; its slug/name/visible_to
  # become the package defaults when `release` doesn't override them.
  service = try([for c in var.components : c.resource if c.type == "service_specification"][0], null)

  visible_to = coalesce(var.release.visible_to, try(local.service.visible_to, null), [var.nrn])

  # Index every component so BOM entry names (and for_each keys) are stable.
  # Zero-padded: Terraform walks maps in lexicographic key order, so a bare
  # tostring(i) puts "10" between "1" and "2" and the BOM stops following the
  # order of var.components once there are ten or more entries. components is an
  # ordered block list, so that shows up as a reordering diff and republishes the
  # revision for nothing.
  indexed = { for i, c in var.components : format("%04d", i) => c }

  # Spec components (service + link): pinned themselves AND expanded into their
  # default action_specifications as children.
  spec_components = { for i, c in local.indexed : i => c if contains(["service_specification", "link_specification"], c.type) }

  # Explicitly-listed action components (rare — actions normally come from a spec).
  action_components = { for i, c in local.indexed : i => c if c.type == "action_specification" }

  # Artifact components, split by intent:
  #   create — inline `meta`, no lookup: register a new revision here
  #   lookup — inline `meta` + lookup=true: resolve an existing artifact by identity
  #   pinned — explicit ids: taken as-is
  art_components      = { for i, c in local.indexed : i => c if c.type == "artifact" }
  artifacts_to_create = { for i, c in local.art_components : i => c if try(c.resource.meta, null) != null && !try(c.resource.lookup, false) }
  artifacts_to_lookup = { for i, c in local.art_components : i => c if try(c.resource.meta, null) != null && try(c.resource.lookup, false) }
  artifacts_existing  = { for i, c in local.art_components : i => c if try(c.resource.meta, null) == null }

  # Friendly, stable name per artifact component (for the BOM and outputs).
  # tonumber() strips the padding the sort key needs: the fallback name is part of
  # the published BOM, so letting it become "artifact-0005" would rename the
  # component for every package that relies on the index fallback.
  art_name = { for i, c in local.art_components : i => try(c.resource.name, "artifact-${tonumber(i)}") }
}

locals {
  # Spec components + their auto-derived default actions. Only actions that
  # already have a snapshot can be pinned — skip any without one rather than
  # send an empty resource_revision_id the package API would reject.
  spec_boms = flatten([
    for i, c in local.spec_components : concat(
      [{
        name                 = "${c.type}/${try(c.resource.slug, i)}"
        resource_type        = c.type
        resource_id          = c.resource.id
        resource_revision_id = c.resource.last_snapshot_id
        parent_id            = try(c.parent_resource.id, null)
      }],
      [
        for a in try(c.resource.action_specifications, []) : {
          name                 = "action_specification/${try(c.resource.slug, i)}/${a.slug}"
          resource_type        = "action_specification"
          resource_id          = a.id
          resource_revision_id = a.last_snapshot_id
          parent_id            = c.resource.id
        } if try(a.last_snapshot_id, "") != ""
      ]
    )
  ])

  # Explicitly-listed action components.
  action_boms = [
    for i, c in local.action_components : {
      name                 = "action_specification/${try(c.resource.slug, i)}"
      resource_type        = "action_specification"
      resource_id          = c.resource.id
      resource_revision_id = c.resource.last_snapshot_id
      parent_id            = try(c.parent_resource.id, null)
    }
  ]

  # Artifact components (register / lookup / pin).
  artifact_boms = concat(
    [for i, c in local.artifacts_to_create : {
      name                 = "artifact/${local.art_name[i]}"
      resource_type        = "artifact"
      resource_id          = nullplatform_artifact.this[i].artifact_id
      resource_revision_id = nullplatform_artifact.this[i].id
      parent_id            = try(c.parent_resource.id, null)
    }],
    [for i, c in local.artifacts_to_lookup : {
      name                 = "artifact/${local.art_name[i]}"
      resource_type        = "artifact"
      resource_id          = data.nullplatform_artifact.this[i].artifact_id
      resource_revision_id = data.nullplatform_artifact.this[i].revision_id
      parent_id            = try(c.parent_resource.id, null)
    }],
    [for i, c in local.artifacts_existing : {
      name                 = "artifact/${local.art_name[i]}"
      resource_type        = "artifact"
      resource_id          = c.resource.resource_id
      resource_revision_id = c.resource.resource_revision_id
      parent_id            = try(c.parent_resource.id, null)
    }],
  )

  # The full bill of materials sent to the package.
  bom = concat(local.spec_boms, local.action_boms, local.artifact_boms)
}

# New artifact revisions declared inline on the package.
resource "nullplatform_artifact" "this" {
  for_each = local.artifacts_to_create

  nrn        = var.nrn
  type       = try(each.value.resource.type, "oci_image")
  meta       = jsonencode(each.value.resource.meta)
  visible_to = local.visible_to
}

# Existing artifacts resolved by identity — no ids in configuration.
data "nullplatform_artifact" "this" {
  for_each = local.artifacts_to_lookup

  nrn  = var.nrn
  type = try(each.value.resource.type, "oci_image")
  meta = jsonencode(each.value.resource.meta)
}

resource "nullplatform_package" "this" {
  nrn        = var.nrn
  slug       = coalesce(var.release.slug, try(local.service.slug, null))
  name       = coalesce(var.release.name, try(local.service.name, null))
  version    = var.release.version
  default    = var.release.default
  visible_to = local.visible_to

  # A component can only be pinned to an existing snapshot. The service spec (BOM
  # root) and every link are mandatory, so fail clearly when one has no snapshot
  # yet instead of publishing a broken revision. (Saving a spec once creates it.)
  lifecycle {
    precondition {
      condition     = local.service != null
      error_message = "components must include a service_specification — it's the root of the package's bill of materials."
    }
    precondition {
      condition     = alltrue([for c in var.components : try(c.resource.last_snapshot_id, "") != "" if contains(["service_specification", "link_specification"], c.type)])
      error_message = "every service_specification / link_specification component must have a snapshot (last_snapshot_id) before it can be pinned. Save/update each spec once so a snapshot exists, then package it."
    }
  }

  dynamic "components" {
    for_each = local.bom
    content {
      name                 = components.value.name
      resource_type        = components.value.resource_type
      resource_id          = components.value.resource_id
      resource_revision_id = components.value.resource_revision_id
      parent_id            = components.value.parent_id
    }
  }
}
