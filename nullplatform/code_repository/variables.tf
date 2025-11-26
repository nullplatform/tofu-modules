variable "git_provider" {
  description = "Git provider to use (GitHub or GitLab)."
  type        = string
  validation {
    condition     = contains(["github", "gitlab"], var.git_provider)
    error_message = "git_provider must be either 'github' or 'gitlab'."
  }
}

# GitLab-specific variables
variable "gitlab_group_path" {
  description = "GitLab group path where repositories will be created."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_group_path != null
    error_message = "group_path is required when git_provider is 'gitlab'."
  }
}

variable "gitlab_access_token" {
  description = "Access token for authenticating with the Git provider API."
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_access_token != null
    error_message = "access_token is required when git_provider is 'gitlab'."
  }
}

variable "gitlab_installation_url" {
  description = "Installation URL for the Git provider integration."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_installation_url != null
    error_message = "installation_url is required when git_provider is 'gitlab'."
  }
}

variable "gitlab_collaborators_config" {
  description = "Configuration for repository collaborators, including their roles and permissions."
  type = object({
    collaborators = list(object({
      id   = string
      role = string
      type = string
    }))
  })
  default = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_collaborators_config != null
    error_message = "collaborators_config is required when git_provider is 'gitlab'."
  }
}

variable "gitlab_repository_prefix" {
  description = "Prefix to use for GitLab repository names."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_repository_prefix != null
    error_message = "gitlab_repository_prefix is required when git_provider is 'gitlab'."
  }
}

variable "gitlab_slug" {
  description = "GitLab project slug identifier."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_slug != null
    error_message = "gitlab_slug is required when git_provider is 'gitlab'."
  }
}

# GitHub-specific variables
variable "github_organization" {
  description = "GitHub organization name for repository creation."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "github" || var.github_organization != null
    error_message = "organization is required when git_provider is 'github'."
  }
}

variable "github_installation_id" {
  description = "GitHub App installation ID for the organization."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "github" || var.github_installation_id != null
    error_message = "organization_installation_id is required when git_provider is 'github'."
  }
}

# Common variables (always required)
variable "np_api_key" {
  description = "Nullplatform API key for authentication."
  type        = string
  sensitive   = true
}

variable "nrn" {
  description = "Nullplatform Resource Name (NRN) — unique identifier for resources."
  type        = string
}
