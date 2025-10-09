variable "group_path" {
  description = "GitLab group path where repositories will be created"
  type        = string
}

variable "access_token" {
  description = "Access token for authenticating with the Git provider API"
  type        = string
  sensitive   = true
}

variable "installation_url" {
  description = "Installation URL for the Git provider integration"
  type        = string
}

variable "np_api_key" {
  description = "Nullplatform API key for authentication"
  type        = string
  sensitive   = true
}

variable "nrn" {
  description = "Nullplatform Resource Name - unique identifier for resources"
  type        = string
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
}

variable "gitlab_repository_prefix" {
  description = "Prefix to use for GitLab repository names"
  type        = string
}

variable "gitlab_name" {
  description = "Name of the GitLab instance or organization"
  type        = string
}

variable "repository_provider" {
  description = "Git repository provider (gitlab or github)"
  type        = string
}

variable "gitlab_slug" {
  description = "GitLab project slug identifier"
  type        = string
}

variable "git_provider" {
  type        = string
  description = "gitlab or github"
}
variable "organization" {
  description = "GitHub organization name for repository creation"
  type        = string
  default     = ""
}

variable "organization_installation_id" {
  description = "GitHub App installation ID for the organization"
  type        = string
  default     = ""
}
