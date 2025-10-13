variable "git_provider" {
  description = "Git provider to use (github or gitlab)"
  type        = string
  validation {
    condition     = contains(["github", "gitlab"], var.git_provider)
    error_message = "git_provider must be either 'github' or 'gitlab'."
  }
}

# Variables específicas de GitLab
variable "group_path" {
  description = "GitLab group path where repositories will be created"
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.group_path != null
    error_message = "group_path is required when git_provider is 'gitlab'."
  }
}

variable "access_token" {
  description = "Access token for authenticating with the Git provider API"
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.access_token != null
    error_message = "access_token is required when git_provider is 'gitlab'."
  }
}

variable "installation_url" {
  description = "Installation URL for the Git provider integration"
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.installation_url != null
    error_message = "installation_url is required when git_provider is 'gitlab'."
  }
}

variable "collaborators_config" {
  description = "Configuration for repository collaborators with their roles and permissions"
  type = object({
    collaborators = list(object({
      id   = string
      role = string
      type = string
    }))
  })
  default = null
  validation {
    condition     = var.git_provider != "gitlab" || var.collaborators_config != null
    error_message = "collaborators_config is required when git_provider is 'gitlab'."
  }
}

variable "gitlab_repository_prefix" {
  description = "Prefix to use for GitLab repository names"
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_repository_prefix != null
    error_message = "gitlab_repository_prefix is required when git_provider is 'gitlab'."
  }
}

variable "gitlab_slug" {
  description = "GitLab project slug identifier"
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_slug != null
    error_message = "gitlab_slug is required when git_provider is 'gitlab'."
  }
}

# Variables específicas de GitHub
variable "organization" {
  description = "GitHub organization name for repository creation"
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "github" || var.organization != null
    error_message = "organization is required when git_provider is 'github'."
  }
}

variable "organization_installation_id" {
  description = "GitHub App installation ID for the organization"
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "github" || var.organization_installation_id != null
    error_message = "organization_installation_id is required when git_provider is 'github'."
  }
}

# Variables comunes (siempre requeridas)
variable "np_api_key" {
  description = "Nullplatform API key for authentication"
  type        = string
  sensitive   = true
}

variable "nrn" {
  description = "Nullplatform Resource Name - unique identifier for resources"
  type        = string
}