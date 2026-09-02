variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name (organization:account format)"
}

variable "git_provider" {
  type        = string
  default     = "github"
  description = "Git provider to fetch service specs from. Supported values: \"github\", \"gitlab\", \"bitbucket\", \"local\"."
  validation {
    condition     = contains(["github", "gitlab", "bitbucket", "local"], var.git_provider)
    error_message = "git_provider must be \"github\", \"gitlab\", \"bitbucket\", or \"local\"."
  }
}

variable "local_specs_path" {
  type        = string
  default     = null
  description = "Absolute path to the local service directory containing specs/. Required when git_provider = \"local\". The directory must contain specs/service-spec.json.tpl and optionally specs/links/*.json.tpl and specs/actions/*.json.tpl."
}

variable "repository_org" {
  type        = string
  default     = "nullplatform"
  description = "GitHub organization or GitLab group owning the service spec repository."
}

variable "repository_name" {
  type        = string
  default     = "service"
  description = "Repository name containing the service spec templates."
}

variable "repository_branch" {
  type        = string
  description = <<-EOT
    Git ref of the service spec repository to read, as a short name and not a full ref
    (e.g. "v1.4.0"). No default and no recommended value: which spec repository an install
    points at is its own choice, so there is no version anyone could pick for it.

    Combine with repository_ref_type, which selects the namespace this name lives in.
  EOT

  validation {
    condition     = var.repository_branch != "" && !contains(["main", "master", "head", "latest"], lower(var.repository_branch))
    error_message = "repository_branch must be a non-empty pinned ref, not empty and not a moving branch."
  }
}

variable "service_path" {
  type        = string
  description = "Path within the repository for the specific service (e.g., databases/postgres/k8s)"
}

variable "service_name" {
  type        = string
  description = "Name of the scope type to be created"
}

variable "available_actions" {
  type        = list(string)
  default     = []
  description = "List of action template names to fetch from the service spec repository"
}

variable "available_links" {
  type        = list(string)
  default     = ["connect"]
  description = "List of link template names to fetch from the service spec repository"
}

variable "repository_token" {
  type        = string
  default     = null
  sensitive   = true
  description = "Access token for private repositories. GitHub: personal access token or fine-grained token. GitLab: Personal Access Token (PAT) with read_api scope."
}

variable "gitlab_host" {
  type        = string
  default     = "gitlab.com"
  description = "GitLab host. Only used when git_provider = \"gitlab\". Override for self-hosted instances (e.g. \"gitlab.mycompany.com\")."
}

variable "bitbucket_email" {
  type        = string
  default     = null
  description = "Bitbucket account email, used only when git_provider = \"bitbucket\". Set it when repository_token is an Atlassian API token: those authenticate ONLY via HTTP Basic \"email:api_token\" and return 401 with a Bearer header. Leave null when repository_token is a Bitbucket workspace/repository access token, which is sent as a Bearer token."
}

variable "extra_visibile_to_nrns" {
  type        = list(string)
  default     = []
  description = "Additional NRNs that should have visibility to the created service specification"
}

variable "dimensions" {
  type        = map(string)
  default     = {}
  description = "Key-value pairs for dimensions to be associated with the service specification"
}

variable "repository_ref_type" {
  type        = string
  default     = "tags"
  description = "Git ref namespace for `repository_branch` on GitHub: \"heads\" for a branch, \"tags\" for a tag, or \"\" to treat it as a raw commit SHA. Defaults to \"heads\", preserving previous behaviour."
  validation {
    condition     = contains(["heads", "tags", ""], var.repository_ref_type)
    error_message = "repository_ref_type must be \"heads\", \"tags\" or \"\"."
  }
}

variable "package" {
  description = <<-EOT
    Register this service definition as a versioned PACKAGE. When set, the module
    publishes a package revision whose bill of materials pins the service
    specification, every action specification, every LINK specification, and the
    artifacts you list — so consumers bind to an immutable revision and later
    template changes never mutate what already runs.

    artifacts: each entry does ONE of:
      • register a new artifact revision — set `meta` (JSON-able object, e.g.
        { url = "https://github.com/acme/svc.git", reference = "main" } for a
        git_repository, or { registry, repository, digest } for an oci_image);
      • look up one registered elsewhere BY IDENTITY (no ids needed) — set
        `lookup = true` + `meta` with the identity fields (url for
        git_repository, or registry+repository for oci_image); add the
        type's own per-revision field to pin a specific revision (reference,
        e.g. a tag, for git_repository; digest, formatted "sha256:<64-hex>",
        for oci_image — the API rejects the other type's field name),
        otherwise the latest revision is used;
      • pin explicit ids — set `resource_id` + `resource_revision_id`.

    An artifact's `name` defaults to "impl" and `type` to "git_repository" —
    a service package is typically a single artifact pointing at the
    service's own implementation repo, so only `meta` (url/reference) needs
    setting on every release. Every other field, at every level, is
    caller-configurable with no other defaults baked in.

    Null (the default) keeps the classic module behavior — no package.
  EOT
  type = object({
    slug       = optional(string)          # default: the service specification slug
    name       = optional(string)          # default: var.service_name
    version    = string                    # semver of the revision this configuration publishes
    default    = optional(bool, true)      # promote each published revision to the package default
    tags       = optional(map(string), {}) # release tags: name => version (requires an API with the package release-tag routes)
    visible_to = optional(list(string))    # default: [var.nrn]
    artifacts = optional(list(object({
      name                 = optional(string, "impl")           # default: a single service-implementation artifact
      type                 = optional(string, "git_repository") # oci_image | oras_artifact | git_repository | blob
      meta                 = optional(any)                      # register (lookup=false) or find (lookup=true)
      lookup               = optional(bool, false)              # true: resolve an EXISTING artifact by meta identity
      resource_id          = optional(string)                   # …or pin explicit ids
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
