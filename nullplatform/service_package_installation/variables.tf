variable "nrn" {
  description = "NRN of the installing organization where the service is installed (e.g. organization=123:account=456). The package is looked up as visible there, installed there, and the agent channel is created there."
  type        = string
}

variable "package_slug" {
  description = "Slug of the service package to install."
  type        = string
}

variable "package_version" {
  description = "Exact semver of the package revision to install (X.Y.Z, without a leading v). Service repositories pass the version of the tag their installation module is referenced at."
  type        = string
}

variable "visible_to" {
  description = "Where inside the installing organization the service can be used. Null uses [nrn]. Every entry must be under the installing organization."
  type        = list(string)
  default     = null
}

variable "agent_tags_selectors" {
  description = "Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = \"runtime\" }."
  type        = map(string)

  validation {
    condition     = length(var.agent_tags_selectors) > 0
    error_message = "agent_tags_selectors must select at least one tag: a channel with an empty selector is refused when it delivers to the agent."
  }
}

variable "service_specification_slug" {
  description = "Slug of the service specification the channel routes. Null uses package_slug, which is what a package published with service_definition gets."
  type        = string
  default     = null
}

variable "channel_sources" {
  description = "Notification sources the agent channel listens to."
  type        = list(string)
  default     = ["service", "telemetry"]
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
