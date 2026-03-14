variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name (organization:account format)"
}

variable "git_provider" {
  type        = string
  default     = "github"
  description = "Git provider to fetch service specs from. Supported values: \"github\", \"gitlab\"."
  validation {
    condition     = contains(["github", "gitlab"], var.git_provider)
    error_message = "git_provider must be \"github\" or \"gitlab\"."
  }
}

variable "repository_org" {
  type        = string
  default     = "nullplatform"
  description = "GitHub organization or GitLab group owning the service spec repository."
}

variable "repository_name" {
  type        = string
  default     = "service"
  description = "Repository name containing the service spec templates."
}

variable "repository_branch" {
  type        = string
  default     = "main"
  description = "Branch of the service spec repository to use. Must be a short branch name (e.g. \"main\"), not a full ref."
}

variable "service_path" {
  type        = string
  description = "Path within the repository for the specific service (e.g., databases/postgres/k8s)"
}

variable "service_name" {
  type        = string
  description = "Name of the scope type to be created"
}

variable "available_actions" {
  type        = list(string)
  default     = []
  description = "List of action template names to fetch from the service spec repository"
}

variable "available_links" {
  type        = list(string)
  default     = ["connect"]
  description = "List of link template names to fetch from the service spec repository"
}

variable "repository_token" {
  type        = string
  default     = null
  sensitive   = true
  description = "Access token for private repositories. GitHub: personal access token or fine-grained token. GitLab: Personal Access Token (PAT) with read_api scope."
}

variable "gitlab_host" {
  type        = string
  default     = "gitlab.com"
  description = "GitLab host. Only used when git_provider = \"gitlab\". Override for self-hosted instances (e.g. \"gitlab.mycompany.com\")."
}

variable "extra_visibile_to_nrns" {
  type        = list(string)
  default     = []
  description = "Additional NRNs that should have visibility to the created service specification"
}

variable "dimensions" {
  type        = map(string)
  default     = {}
  description = "Key-value pairs for dimensions to be associated with the service specification"
}
