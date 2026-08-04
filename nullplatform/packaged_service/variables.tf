variable "service_specification" {
  description = <<-EOT
    The nullplatform_service_specification resource to package — pass the whole
    resource object (e.g. `nullplatform_service_specification.my_service`). The
    module reads `.id`, `.slug`, `.name`, `.visible_to`, `.last_snapshot_id` and
    `.action_specifications` from it, so the provider must be recent enough to
    expose the last two (see providers.tf).
  EOT
  type        = any
}

variable "link_specification" {
  description = <<-EOT
    Optional nullplatform_link_specification resource to include in the package —
    pass the whole resource object. Reads `.id`, `.last_snapshot_id` and
    `.action_specifications`. Leave null to package a service that has no link.
  EOT
  type        = any
  default     = null
}

variable "package_version" {
  description = <<-EOT
    Semver of the package revision this configuration publishes (e.g. "0.0.1").

    NOTE: named `package_version`, not `version`, because `version` is a reserved
    module meta-argument in Terraform/OpenTofu (it would be parsed as a registry
    version constraint and rejected on a git source). Bump to publish a new
    revision; re-applying the same version with the same BOM is a no-op.
  EOT
  type        = string
}

variable "alias" {
  description = <<-EOT
    Movable version pointers. For now only the `default` key is honored and maps
    to the package's `default_version`; omit it and `default_version` falls back
    to `package_version`. Arbitrary aliases (e.g. `beta`) will map to package
    tags in a later revision of this module — passing them today is ignored.
  EOT
  type        = map(string)
  default     = {}
}

variable "artifacts" {
  description = <<-EOT
    Artifacts to pin into the package revision. Each entry does ONE of:
      • register a new artifact revision — set `meta`;
      • look up one registered elsewhere by identity — `lookup = true` + `meta`;
      • pin explicit ids — `resource_id` + `resource_revision_id`.
    Same shape as the scope_definition module's `package.artifacts`.
  EOT
  type = list(object({
    name                 = string
    type                 = optional(string, "oci_image") # oci_image | oras_artifact | git_repository | blob
    meta                 = optional(any)
    lookup               = optional(bool, false)
    resource_id          = optional(string)
    resource_revision_id = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for a in var.artifacts :
      (a.meta != null) != (a.resource_id != null && a.resource_revision_id != null)
    ])
    error_message = "Each artifact must EITHER set `meta` (register or look up) OR both `resource_id` and `resource_revision_id` — not neither, not both."
  }
  validation {
    condition     = alltrue([for a in var.artifacts : a.lookup ? a.meta != null : true])
    error_message = "`lookup = true` requires `meta` with the identity fields of the existing artifact."
  }
}

variable "nrn" {
  description = "Owner NRN for the package and any artifacts it registers."
  type        = string
}

variable "slug" {
  description = "Package slug (unique per NRN). Defaults to the service specification's slug."
  type        = string
  default     = null
}

variable "name" {
  description = "Package display name. Defaults to the service specification's name."
  type        = string
  default     = null
}

variable "visible_to" {
  description = "Visibility for the package and its artifacts. Defaults to the service specification's `visible_to`."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Package release tags: name => version. Reserved names `default`/`latest` are not allowed here (use `alias`)."
  type        = map(string)
  default     = {}
}
