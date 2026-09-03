variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name (organization:account format)"
  default     = null
}

variable "api_key" {
  description = "API key for authenticating with the nullplatform API"
  type        = string
  sensitive   = true
}

variable "tags_selectors" {
  description = "Map of tags used to select and filter agents"
  type        = map(string)
}

variable "channel_sources" {
  type        = list(string)
  description = "List of sources for the notification channel (e.g., ['monitoring', 'alerts'])"
  default     = ["service"]
}

variable "channel_type" {
  type        = string
  description = "Type of the notification channel (e.g., 'agent')"
  default     = "agent"
}

variable "service_specification_slug" {
  type        = string
  description = "The slug of the service definition"
  default     = null
}

variable "repository_service_spec_repo" {
  type        = string
  default     = ""
  description = "GitHub repository name containing the service specs (used to build the agent cmdline path). Required when worker_orchestrator = false; unused (the worker's baked entrypoint is used instead) when true."
}

variable "base_clone_path" {
  type        = string
  default     = "/home/agent/.np"
  description = "Base path where the service repository is cloned inside the agent pod. Unused when worker_orchestrator = true."
}

variable "service_path" {
  type        = string
  default     = ""
  description = "Path to the service directory within the repository (e.g., databases/postgres/k8s). Only consulted when worker_orchestrator = false — empty omits the path segment."
}

variable "agent_arguments" {
  type        = list(string)
  default     = []
  description = "Arguments to pass to the agent entrypoint command. Unused when worker_orchestrator = true."
}

variable "description" {
  description = "Description shown for the notification channel."
  type        = string
  default     = ""
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
  description = "Package/service slug — the package-exec NP_PLUGIN and default entrypoint path. Required when worker_orchestrator = true."
  type        = string
  default     = ""
}

variable "entrypoint" {
  description = "Override the worker's baked entrypoint path. Defaults to /app/packages/<package_slug>/entrypoint."
  type        = string
  default     = ""
}
