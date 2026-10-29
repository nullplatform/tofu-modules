variable "nrn" {
  description = "NRN of the installing organization where the scope is installed (e.g. organization=123:account=456). The package is looked up as visible there, and the installation, scope type, NRN settings, scope-configuration schema and agent channel are created there."
  type        = string
}

variable "package_slug" {
  description = "Slug of the scope package to install."
  type        = string
}

variable "package_version" {
  description = "Exact semver of the package revision to install (X.Y.Z, without a leading v). Scope repositories pass the version of the tag their installation module is referenced at."
  type        = string
}

variable "local_specs_path" {
  description = <<-EOT
    Absolute path to the scope's directory in a checkout of its repository: the
    one holding `specs/scope-type-definition.json.tpl`,
    `specs/notification-channel.json.tpl` and, with create_scope_configuration,
    `specs/scope-configuration.json.tpl`. A scope repository's installation
    module passes its own directory (`abspath("$${path.module}/..")`), so the
    per-organization pieces come from the same tag as the package.
  EOT
  type        = string
}

variable "service_path" {
  description = "Path of the scope inside its repository (e.g. \"lambda\"), exported as SERVICE_PATH to the channel template."
  type        = string
}

variable "visible_to" {
  description = "Where inside the installing organization the scope can be used. Null uses [nrn]. Every entry must be under the installing organization."
  type        = list(string)
  default     = null
}

variable "agent_tags_selectors" {
  description = "Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = \"runtime\" }."
  type        = map(string)
}

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

variable "scope_type_name" {
  description = "Name of the scope type. Null uses the template's; override it when that name collides with a scope type already in the organization, such as one registered with scope_definition."
  type        = string
  default     = null
}

variable "create_scope_configuration" {
  description = "Create the scope-configuration provider specification from specs/scope-configuration.json.tpl. Set it to true only when the scope ships that file."
  type        = bool
  default     = false
}

variable "scope_configuration_name" {
  description = "Name of the scope-configuration provider specification. Null uses the template's; override it when that name collides with one already visible in the organization."
  type        = string
  default     = null
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
