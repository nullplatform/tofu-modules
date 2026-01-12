################################################################################
# Scope Definition Module Variables
################################################################################

variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name (organization:account format)"
}
variable "git_provider" {
  type        = string
  default     = "github"
  description = "Git provider (e.g., github, gitlab)"
}
variable "git_user" {
  type        = string
  default     = null
  description = "Git provider (e.g., github, gitlab)"
}
variable "git_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Git provider (e.g., github, gitlab)"
}
variable "git_repo" {
  type        = string
  default     = "nullplatform/services"
  description = "GitHub repository URL containing templates"
}

variable "workflow_override_path" {
  type        = string
  default     = null
  description = "Path to a custom workflow file to override the default one"
}

variable "workflow_override_values" {
  type        = string
  default     = null
  description = "Values to override in the workflow file"

}

variable "git_ref" {
  type        = string
  default     = "main"
  description = "Git reference (branch, tag, or commit)"
}

variable "git_service_path" {
  type        = string
  description = "Path within the repository for the specific service (e.g., databases/postgres/k8s)"
}

variable "service_name" {
  type        = string
  description = "Name of the scope type to be created"
}
variable "service_description" {
  type        = string
  description = "Description of the scope type to be created"
}

variable "use_tpl_files" {
  type        = bool
  default     = false
  description = "Whether to use .tpl files (true) or .json files (false) for templates"
}

# NRN Patch Configuration
variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
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

variable "tags_selectors" {
  description = "Map of tags used to select and filter agents"
  type        = map(string)
  default     = {}
}