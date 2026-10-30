variable "nrn" {
  description = "NRN of the installing organization where the scope is installed (e.g. organization=123:account=456). The package is looked up as visible there, and the installation, scope type, NRN settings, scope-configuration schema and agent channel are created there."
  type        = string
}

variable "package_slug" {
  description = "Slug of the scope package to install."
  type        = string
}

variable "package_version" {
  description = "Exact semver of the package revision to install (X.Y.Z, without a leading v). New scopes are born with it; moving to another version is changing this value."
  type        = string
}

variable "visible_to" {
  description = "Where inside the installing organization the scope can be used. Null uses [nrn]. Every entry must be under the installing organization."
  type        = list(string)
  default     = null
}

################################################################################
# Scope type
#
# Same inputs as scope_definition's, so a catalog entry that fed that module
# feeds this one unchanged.
################################################################################

variable "service_spec_name" {
  description = "Name of the scope type developers pick when they create a scope. Same input as scope_definition's. While a copy of the same scope registered with scope_definition lives in the organization, pick a name that tells the two apart."
  type        = string
}

variable "service_spec_description" {
  description = "Description of the scope type. Same input as scope_definition's."
  type        = string
}

################################################################################
# Templates: the scope-configuration schema and the channel
#
# The only files this module still needs from the scope repository. They are
# read from a checkout (local_specs_path) or fetched over HTTP from
# <repository_scope_template>/<repository_scope_template_branch>/<service_path>/specs/,
# the same URL shape scope_definition uses.
################################################################################

variable "local_specs_path" {
  description = <<-EOT
    Absolute path to the scope's directory in a checkout of its repository: the
    one holding `specs/scope-configuration.json.tpl` and
    `specs/notification-channel.json.tpl`. When set, the templates are read from
    disk and `repository_scope_template(_branch)` are not used. A scope
    repository's installation module passes its own directory
    (`abspath("$${path.module}/..")`). Null (the default) fetches the templates
    over HTTP.
  EOT
  type        = string
  default     = null
}

variable "repository_scope_template" {
  description = <<-EOT
    Base raw URL of the scope repository, up to the ref namespace, e.g.
    `https://raw.githubusercontent.com/nullplatform/scopes/refs/tags`. Same
    input as scope_definition's. Required, together with
    `repository_scope_template_branch`, when a template is fetched over HTTP:
    `create_scope_configuration` or `create_agent_channel` without
    `local_specs_path`.
  EOT
  type        = string
  default     = null

  validation {
    condition = (
      var.local_specs_path != null
      || !(var.create_scope_configuration || var.create_agent_channel)
      || (var.repository_scope_template != null && var.repository_scope_template_branch != null)
    )
    error_message = "repository_scope_template and repository_scope_template_branch are required to fetch the scope-configuration or channel template over HTTP. Set them, or pass local_specs_path."
  }
}

variable "repository_scope_template_branch" {
  description = "Ref the templates are fetched at, a tag or a branch name under `repository_scope_template`. Pin the tag the installed package version was published from, so the schema and the channel match the specification."
  type        = string
  default     = null
}

variable "service_path" {
  description = "Path of the scope inside its repository (e.g. \"lambda\"). Part of the template URL, and exported as SERVICE_PATH to the channel template. Required when a template is fetched over HTTP, and with create_agent_channel."
  type        = string
  default     = null

  validation {
    condition = (
      var.service_path != null
      || (!var.create_agent_channel && !(var.create_scope_configuration && var.local_specs_path == null))
    )
    error_message = "service_path is required when create_agent_channel is true, and when the scope-configuration template is fetched over HTTP (create_scope_configuration without local_specs_path)."
  }
}

################################################################################
# Scope configuration
################################################################################

variable "create_scope_configuration" {
  description = "Create the scope-configuration provider specification from specs/scope-configuration.json.tpl. Set it to true only when the scope ships that file."
  type        = bool
  default     = false
}

variable "scope_configuration_name_override" {
  description = "Name of the scope-configuration provider specification. Null uses the template's; override it when that name collides with one already visible in the organization. Same input as scope_definition's."
  type        = string
  default     = null
}

################################################################################
# NRN settings
################################################################################

variable "np_api_key" {
  description = "nullplatform API key for the `np nrn patch` that sets the scope's metrics and logs providers. Null uses the NP_API_KEY of the environment running the apply."
  type        = string
  default     = null
  sensitive   = true
}

variable "external_metrics_provider" {
  description = "Metrics provider recorded in the NRN settings for this scope."
  type        = string
  default     = "externalmetrics"
}

variable "external_logging_provider" {
  description = "Logs provider recorded in the NRN settings for this scope."
  type        = string
  default     = "external"
}

################################################################################
# Agent channel
################################################################################

variable "create_agent_channel" {
  description = "Create the agent channel that routes the scope's actions to the package worker. Turn it off when the organization creates its channels in a separate bindings layer with scope_definition_agent_association."
  type        = bool
  default     = true
}

variable "agent_tags_selectors" {
  description = "Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = \"runtime\" }. Required with create_agent_channel."
  type        = map(string)
  default     = null

  validation {
    condition     = !var.create_agent_channel || length(coalesce(var.agent_tags_selectors, {})) > 0
    error_message = "agent_tags_selectors must select at least one tag when create_agent_channel is true: a channel with an empty selector is refused when it delivers to the agent."
  }
}

variable "channel_description" {
  description = "Description of the agent channel. Null uses \"<package_slug> package worker\"."
  type        = string
  default     = null
}

variable "entrypoint" {
  description = "Command the channel sends to the worker. Empty uses the module default (/app/packages/<package_slug>/entrypoint). worker-bridge images ignore it and run their baked NP_SCOPE_ENTRYPOINT."
  type        = string
  default     = ""
}
