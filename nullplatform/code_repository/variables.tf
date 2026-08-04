variable "git_provider" {
  description = "Git provider to use (GitHub, GitLab, Azure DevOps or Bitbucket)."
  type        = string
  validation {
    condition     = contains(["github", "gitlab", "azure", "bitbucket"], var.git_provider)
    error_message = "git_provider must be one of 'github', 'gitlab', 'azure' or 'bitbucket'."
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

# Neither of the two below is read by main.tf, so tflint's
# terraform_unused_declarations flags them. They are NOT removed: their own
# validation blocks make them REQUIRED whenever git_provider is "gitlab", so every
# gitlab caller passes them today and dropping them would break those callers with
# "Unsupported argument". Whether the module should still demand values it never
# sends anywhere is a separate question from this change.
# tflint-ignore: terraform_unused_declarations
variable "gitlab_repository_prefix" {
  description = "Prefix to use for GitLab repository names."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "gitlab" || var.gitlab_repository_prefix != null
    error_message = "gitlab_repository_prefix is required when git_provider is 'gitlab'."
  }
}

# tflint-ignore: terraform_unused_declarations
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

# Azure-specific variables
variable "azure_project" {
  description = "Azure devops project name"
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "azure" || var.azure_project != null
    error_message = "project is required when git_provider is 'azure'."
  }
}

variable "azure_access_token" {
  description = "Azure devops personal access token"
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "azure" || var.azure_access_token != null
    error_message = "access_token is required when git_provider is 'azure'."
  }
}

variable "azure_agent_pool" {
  description = "Azure devops CI agent pool"
  type        = string
  default     = "Default"
  validation {
    condition     = var.git_provider != "azure" || var.azure_agent_pool != null
    error_message = "agent_pool is required when git_provider is 'azure'."
  }
}

# Bitbucket-specific variables
#
# There are deliberately no credential variables: the `bitbucket` specification
# declares none. BITBUCKET_EMAIL and BITBUCKET_API_TOKEN are set on the
# application-lifecycle-manager deployment instead, because nullplatform nullifies
# secret attribute values on authenticated provider reads.
variable "bitbucket_workspace" {
  description = "Bitbucket workspace that owns the repositories."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "bitbucket" || var.bitbucket_workspace != null
    error_message = "bitbucket_workspace is required when git_provider is 'bitbucket'."
  }
}

variable "bitbucket_project_key" {
  description = "Bitbucket project key under which repositories are created."
  type        = string
  default     = null
  validation {
    condition     = var.git_provider != "bitbucket" || var.bitbucket_project_key != null
    error_message = "bitbucket_project_key is required when git_provider is 'bitbucket'."
  }
}

variable "bitbucket_installation_url" {
  description = "Base URL for the Bitbucket integration. Defaults to Bitbucket Cloud."
  type        = string
  default     = "https://bitbucket.org"
}

variable "bitbucket_collaborators" {
  description = "Collaborators to grant repository access to. Each entry has an id, a role and a type."
  type = list(object({
    id   = string
    role = string
    type = string
  }))
  default = []
}


variable "nrn" {
  description = "Nullplatform Resource Name (NRN) — unique identifier for resources."
  type        = string
}

variable "dimensions" {
  description = "Dimensions to segment the nullplatform provider config (e.g. by region, environment)"
  type        = map(string)
  default     = {}
}
