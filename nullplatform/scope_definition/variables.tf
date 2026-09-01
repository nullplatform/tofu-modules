################################################################################
# Template Paths and Names
################################################################################

variable "repository_service_spec" {
  description = "repository of service spec"
  type        = string
  default     = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"

}

variable "repository_service_spec_branch" {
  description = "branch reference of service spec"
  type        = string
  default     = "main"

}

variable "repository_scope_template" {
  description = "repository of scope template"
  type        = string
  default     = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"

}


variable "repository_scope_template_branch" {
  description = "branch reference of scope template"
  type        = string
  default     = "main"

}

variable "repository_action_templates" {
  description = "repository of action template"
  type        = string
  default     = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"

}

variable "repository_action_templates_branch" {
  description = "branch reference of action template"
  type        = string
  default     = "main"

}

variable "service_path" {
  description = "Path within the repository where the service specification files are stored (e.g., 'services/api')"
  type        = string
  default     = "k8s"
}

variable "repo_path" {
  description = "Base path to the repository used as context for gomplate template rendering"
  type        = string
  default     = "/root/.np/nullplatform/scopes"
}

variable "action_spec_names" {
  description = <<-EOT
    List of action specification template names to fetch and create for scope
    operations. Default `null` -> use the `available_actions` array from the
    scope's `service-spec.json.tpl` (fetched via `repository_service_spec` /
    `service_path`). Set this explicitly only when the spec's list is wrong
    for your case or the spec predates the `available_actions` field.
  EOT
  type        = list(string)
  default     = null
}

################################################################################
# Service Specification Configuration
################################################################################

variable "service_spec_name" {
  description = "Name of the service that will be created from the specification template"
  type        = string
  default     = "Containers"
}

variable "service_spec_description" {
  description = "Description of the created service or associated scope type"
  type        = string
  default     = "Docker containers on pods"
}

################################################################################
# Nullplatform / Environment Context
################################################################################

variable "nrn" {
  description = "Unique NRN identifier of the environment or resource in nullplatform"
  type        = string
}

variable "np_api_key" {
  description = "Nullplatform API key used for executing local commands (e.g., 'np nrn patch')"
  type        = string
  sensitive   = true
}

################################################################################
# External Providers (Metrics / Logging)
################################################################################

variable "external_metrics_provider" {
  description = "Name of the external metrics provider for monitoring integration"
  type        = string
  default     = "externalmetrics"
}

variable "external_logging_provider" {
  description = "Name of the external log provider"
  type        = string
  default     = "external"
}

variable "create_scope_configuration" {
  type        = bool
  default     = false
  description = "Whether to fetch and apply scope-configuration.json.tpl from the template repo. Set to true only if the file exists for this scope."
}

variable "scope_configuration_name_override" {
  description = <<-EOT
    Optional override for the `name` of the `nullplatform_provider_specification`
    created from `scope-configuration.json.tpl` (when `create_scope_configuration = true`).

    Default `null` -> use the `name` field from the template, preserving
    current behavior. Set to a string when consuming this module from a
    setup where the template's name would collide with an existing
    org-visible provider_specification (e.g., a hub/principal account
    already registered the canonical "Static Files" / "AWS Lambda" name
    org-wide, and a sibling spoke account needs an account-local copy
    with a distinct name).

    The `slug` is auto-derived server-side from the name; pass a name
    that will produce a unique slug per the API uniqueness constraints
    (name must be unique across `visible_to` overlaps in the same org).

    Example:

      scope_configuration_name_override = "Static Files Galicia 3"

    Default = null (no override, backwards compatible).
  EOT
  type        = string
  default     = null
}

################################################################################
# Visibility (cross-account sharing)
################################################################################

variable "extra_visible_to_nrns" {
  description = <<-EOT
    Additional NRNs to add to `visible_to` of the `nullplatform_service_specification`
    and `nullplatform_provider_specification` created by this module. The base
    visible_to (the spec template's value for the service_spec, and `[var.nrn]`
    for the provider_spec) is preserved; this list is appended.

    Use case: share a scope_definition with sibling accounts in the same
    organization without duplicating it per account. Example:

      extra_visible_to_nrns = ["organization=1636958496"]

    makes the spec consumable by every account under that organization.
    Default = [] (no extra visibility, backwards compatible).
  EOT
  type        = list(string)
  default     = []
}

################################################################################
# Package (optional)
################################################################################

variable "package" {
  description = <<-EOT
    Register this scope definition as a versioned PACKAGE. When set, the module
    publishes a package revision whose bill of materials pins the service
    specification, every action specification, and the artifacts you list —
    so scopes bind to an immutable revision and later template changes never
    mutate what already runs.

    artifacts: each entry does ONE of:
      • register a new artifact revision — set `meta` (JSON-able object, e.g.
        { registry = "ghcr.io", repository = "acme/img", digest = "sha256:…" });
      • look up one registered elsewhere BY IDENTITY (no ids needed) — set
        `lookup = true` + `meta` with the identity fields (e.g. registry +
        repository; add digest/reference to pin a specific revision, otherwise
        the latest revision is used);
      • pin explicit ids — set `resource_id` + `resource_revision_id`.

    Null (the default) keeps the classic module behavior — no package.
  EOT
  type = object({
    slug       = optional(string)          # default: the service specification slug
    name       = optional(string)          # default: var.service_spec_name
    version    = string                    # semver of the revision this configuration publishes
    default    = optional(bool, true)      # promote each published revision to the package default
    tags       = optional(map(string), {}) # release tags: name => version (requires an API with the package release-tag routes)
    visible_to = optional(list(string))    # default: [var.nrn]
    artifacts = optional(list(object({
      name                 = string
      type                 = optional(string, "oci_image") # oci_image | oras_artifact | git_repository | blob
      meta                 = optional(any)                 # register (lookup=false) or find (lookup=true)
      lookup               = optional(bool, false)         # true: resolve an EXISTING artifact by meta identity
      resource_id          = optional(string)              # …or pin explicit ids
      resource_revision_id = optional(string)
    })), [])
  })
  default = null

  validation {
    condition = var.package == null ? true : alltrue([
      for a in var.package.artifacts :
      (a.meta != null) != (a.resource_id != null && a.resource_revision_id != null)
    ])
    error_message = "Each package artifact must EITHER set `meta` (register or look up) OR both `resource_id` and `resource_revision_id` — not neither, not both."
  }

  validation {
    condition = var.package == null ? true : alltrue([
      for a in var.package.artifacts : a.lookup ? a.meta != null : true
    ])
    error_message = "`lookup = true` requires `meta` with the identity fields of the existing artifact."
  }
}
