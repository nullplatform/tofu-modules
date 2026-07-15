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
  description = "GitHub repository name containing the service specs (used to build the agent cmdline path)"
}

variable "base_clone_path" {
  type        = string
  default     = "/root/.np"
  description = "Base path where the service repository is cloned inside the agent pod"
}

variable "service_path" {
  type        = string
  description = "Path to the service directory within the repository (e.g., databases/postgres/k8s)"
}

variable "agent_arguments" {
  type        = list(string)
  default     = []
  description = "Arguments to pass to the agent entrypoint command"
}

variable "description" {
  description = "Description shown for the notification channel."
  type        = string
  default     = ""
}
