variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name (organization:account format)"
}

variable "git_provider" {
  type        = string
  default     = "github"
  description = "Git provider to fetch service specs from. Supported values: \"github\", \"gitlab\", \"bitbucket\", \"local\"."
  validation {
    condition     = contains(["github", "gitlab", "bitbucket", "local"], var.git_provider)
    error_message = "git_provider must be \"github\", \"gitlab\", \"bitbucket\", or \"local\"."
  }
}

variable "local_specs_path" {
  type        = string
  default     = null
  description = "Absolute path to the local service directory containing specs/. Required when git_provider = \"local\". The directory must contain specs/service-spec.json.tpl and optionally specs/links/*.json.tpl and specs/actions/*.json.tpl."
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
  description = <<-EOT
    Git ref of the service spec repository to read, as a short name and not a full ref
    (e.g. "v1.4.0"). No default and no recommended value: which spec repository an install
    points at is its own choice, so there is no version anyone could pick for it.

    Combine with repository_ref_type, which selects the namespace this name lives in.
  EOT

  validation {
    condition     = var.repository_branch != "" && !contains(["main", "master", "head", "latest"], lower(var.repository_branch))
    error_message = "repository_branch must be a non-empty pinned ref, not empty and not a moving branch."
  }
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

variable "bitbucket_email" {
  type        = string
  default     = null
  description = "Bitbucket account email, used only when git_provider = \"bitbucket\". Set it when repository_token is an Atlassian API token: those authenticate ONLY via HTTP Basic \"email:api_token\" and return 401 with a Bearer header. Leave null when repository_token is a Bitbucket workspace/repository access token, which is sent as a Bearer token."
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

variable "repository_ref_type" {
  type        = string
  default     = "tags"
  description = "Git ref namespace for `repository_branch` on GitHub: \"heads\" for a branch, \"tags\" for a tag, or \"\" to treat it as a raw commit SHA. Defaults to \"heads\", preserving previous behaviour."
  validation {
    condition     = contains(["heads", "tags", ""], var.repository_ref_type)
    error_message = "repository_ref_type must be \"heads\", \"tags\" or \"\"."
  }
}
