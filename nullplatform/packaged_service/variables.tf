variable "nrn" {
  description = "Owner NRN — the org/account/namespace the package and its artifacts live in."
  type        = string
}

variable "components" {
  description = <<-EOT
    The package's bill of materials, as one flat list that mirrors
    nullplatform_package.components. Each entry:

      type            = "service_specification" | "link_specification" | "artifact" | "action_specification"
      resource        = the whole TF resource to pin (for artifact: an inline object, see below)
      parent_resource = (optional) the resource this hangs off — e.g. a link's service

    Pass whole resources, not ids — the module reads each one's id + snapshot
    itself. Exactly one service_specification is required (the BOM root). For
    every service_specification / link_specification, its default
    action_specifications are pinned automatically as children — don't list them.

    An artifact's `resource` is an inline object doing exactly ONE of:
      register  { type = "oci_image", meta = {…} }                 # new revision
      look up   { type = "oci_image", meta = {…}, lookup = true }   # resolve by identity
      pin       { resource_id = "…", resource_revision_id = "…" }   # existing ids
    `type` defaults to "oci_image"; `name` (optional) labels it in the BOM/outputs.
  EOT
  type = list(object({
    type            = string
    resource        = any
    parent_resource = optional(any)
  }))

  validation {
    condition     = length([for c in var.components : c if c.type == "service_specification"]) == 1
    error_message = "components must contain exactly one service_specification (the bill-of-materials root)."
  }
  validation {
    condition     = alltrue([for c in var.components : contains(["service_specification", "link_specification", "action_specification", "artifact"], c.type)])
    error_message = "each component `type` must be one of: service_specification, link_specification, action_specification, artifact."
  }
  validation {
    condition = alltrue([
      for c in var.components :
      (try(c.resource.meta, null) != null) != (try(c.resource.resource_id, null) != null && try(c.resource.resource_revision_id, null) != null)
      if c.type == "artifact"
    ])
    error_message = "each artifact `resource` must set EITHER `meta` (register / look up) OR both `resource_id` and `resource_revision_id` — not neither, not both."
  }
}

variable "release" {
  description = <<-EOT
    How this revision is published. `version` lives here (nested) because a
    top-level `version` is Terraform's reserved registry-module argument and
    errors on a git/local source. slug/name/visible_to default to the service
    spec's when unset.
  EOT
  type = object({
    version    = string                 # semver of the revision to publish; bump for a new revision
    default    = optional(bool, true)   # promote this revision to the package default
    slug       = optional(string)       # package slug — defaults to the service spec's slug
    name       = optional(string)       # display name — defaults to the service spec's name
    visible_to = optional(list(string)) # visibility    — defaults to the service spec's visible_to
  })
}
