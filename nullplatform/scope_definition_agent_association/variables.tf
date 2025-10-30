
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

variable "service_path" {
  description = "Path to the service directory within the repository structure"
  type        = string
  default     = "k8s"
}
variable "nrn" {
  type = string

}
variable "np_api_key" {
  type = string

}
variable "service_specification_slug" {

}
variable "service_specification_id" {

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