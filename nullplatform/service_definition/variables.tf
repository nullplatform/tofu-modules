variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name (organization:account format)"
}

variable "repository_service_spec_org" {
  type        = string
  default     = "nullplatform"
  description = "GitHub organization owning the service spec repository"
}

variable "repository_service_spec_repo" {
  type        = string
  default     = "service"
  description = "GitHub repository name containing service spec templates"
}

variable "repository_service_spec_branch" {
  type        = string
  default     = "main"
  description = "Branch of the service spec repository to use"
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

variable "github_token" {
  type        = string
  default     = null
  sensitive   = true
  description = "GitHub token for private repository access. If null, the repository is assumed to be public."
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
