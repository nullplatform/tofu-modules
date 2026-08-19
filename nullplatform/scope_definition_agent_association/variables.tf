
variable "enabled_override" {
  description = "Enable custom overrides for scope configurations via command line"
  type        = bool
  default     = false
}

variable "worker_orchestrator" {
  description = <<-EOT
    Emit a worker-orchestrator (package-exec) channel instead of the legacy
    git-clone exec channel. When true, the channel routes package-exec commands
    to an agent that spawns the package's worker image and runs its baked
    entrypoint — matching what `np package publish` registers. Requires
    package_slug; set tags_selectors to select the agent (e.g. {package = slug}).
  EOT
  type        = bool
  default     = false
}

variable "package_slug" {
  description = "Package/scope slug — the package-exec NP_PLUGIN and default entrypoint path. Required when worker_orchestrator = true."
  type        = string
  default     = ""
}

variable "entrypoint" {
  description = "Override the worker's baked entrypoint path. Defaults to /app/packages/<package_slug>/entrypoint."
  type        = string
  default     = ""
}

variable "overrides_service_path" {
  description = "Local filesystem path to the directory containing override configurations"
  type        = string
  default     = null
}
variable "override_repo_path" {
  description = "Local filesystem path where the scope repository will be cloned"
  type        = string
  default     = null
}

# Retained optional input for backward compatibility; the notification-channel
# template is sourced from repository_notification_channel(_branch), so this value
# is not consumed here.
# tflint-ignore: terraform_unused_declarations
variable "github_repo_url" {
  description = "GitHub repository URL containing scope and action templates"
  type        = string
  default     = "https://github.com/nullplatform/scopes"

  validation {
    condition     = can(regex("^https?://", var.github_repo_url))
    error_message = "github_repo_url must be a valid HTTP(S) URL."
  }
}

# Retained optional input for backward compatibility; see github_repo_url above.
# tflint-ignore: terraform_unused_declarations
variable "github_ref" {
  description = "Git reference to use (branch name, tag, or commit SHA)"
  type        = string
  default     = "beta"
}

variable "repository_notification_channel" {
  description = "repository of notification channel template"
  type        = string
  default     = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"
}

variable "repository_notification_channel_branch" {
  description = "branch reference of notification channel template"
  type        = string
  default     = "main"
}

variable "service_path" {
  description = "Path to the service directory within the repository structure"
  type        = string
  default     = "k8s"
}
variable "nrn" {
  description = "Nullplatform Resource Name (NRN) — unique identifier for the target resource"
  type        = string
}
variable "api_key" {
  description = "API key for authenticating with the nullplatform API"
  type        = string
  sensitive   = true
}

variable "scope_specification_id" {
  description = "ID of the scope (service) specification to associate with the agent notification channel"
  type        = string
}

variable "scope_specification_slug" {
  description = "Slug of the scope (service) specification, used as a filter in the notification channel"
  type        = string
}

variable "repo_path" {
  description = "Local filesystem path where the scope repository will be cloned"
  type        = string
  default     = "/root/.np/nullplatform/scopes"
}
variable "tags_selectors" {
  description = "Map of tags used to select and filter channels and agents"
  type        = map(string)
}

variable "description" {
  description = "Description shown for the notification channel."
  type        = string
  default     = "Routes Containers deployments agent"
}

variable "extra_filters" {
  description = <<-EOT
    Additional filter expression to merge with the base template filters using $and.
    Accepts any valid MongoDB-style filter expression, including logical operators
    ($and, $or, $nor, $not) and comparison operators ($eq, $ne, $in, $nin, $gt,
    $gte, $lt, $lte, $regex). If null, only the base template filters are applied.

    Examples:
      Simple equality:    { "dimensions.environment" = "production" }
      Comparison:         { "action" = { "$in" = ["deployment:create", "deployment:update"] } }
      Logical OR:         { "$or" = [{ "details.namespace.slug" = "prod" }, { "details.namespace.slug" = "staging" }] }
      Negation:           { "$not" = { "entity_data.status" = "failed" } }
      Combined:           { "$and" = [{ "action" = { "$regex" = "^deployment" } }, { "$or" = [...] }] }
  EOT
  type        = any
  default     = null
}
