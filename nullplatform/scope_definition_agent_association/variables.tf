
variable "enabled_override" {
  description = "Enable custom overrides for scope configurations via command line"
  type        = bool
  default     = false
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

variable "github_repo_url" {
  description = "GitHub repository URL containing scope and action templates"
  type        = string
  default     = "https://github.com/nullplatform/scopes"
}

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
  type = string

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

variable "extra_filters" {
  description = "Additional filter conditions to AND with the base template filters. Each element is a filter condition object (e.g. { \"dimensions.environment\" = \"production\" })."
  type        = list(any)
  default     = []
}
