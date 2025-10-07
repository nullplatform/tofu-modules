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
  description = "Git username for authentication"
}
variable "git_password" {
  type        = string
  default     = null
  sensitive = true
  description = "Git password or token for authentication"
}
variable "git_repo" {
  type        = string
  default     = "nullplatform/scopes"
  description = "GitHub repository containing templates"
}

variable "workflow_override_path" {
  type = string
  default = null
  description = "Path to a custom workflow file to override the default one"
}

variable "workflow_override_values" {
  type = string
  default = null
  description = "Values to override in the workflow file"
  
}

variable "git_ref" {
  type        = string
  default     = "main"
  description = "Git reference (branch, tag, or commit)"
}

variable "git_scope_path" {
  type        = string
  default     = "k8s"
  description = "Path within the repository for the specific scope (e.g., k8s, ecs)"
}

variable "scope_name" {
  type        = string
  description = "Name of the scope type to be created"
}
variable "scope_description" {
  type        = string
  description = "Description of the scope type to be created"
} 

variable "action_spec_names" {
  type = list(string)
  default = [
    "create-scope",
    "delete-scope",
    "start-initial",
    "start-blue-green",
    "finalize-blue-green",
    "rollback-deployment",
    "delete-deployment",
    "switch-traffic",
    "set-desired-instance-count",
    "pause-autoscaling",
    "resume-autoscaling",
    "restart-pods",
    "kill-instances"
  ]
  description = "List of action specification template names to fetch and create"
}

variable "logs_provider" {
  type        = string
  default     = "external"
  description = "The logs provider to be used"
}

variable "metrics_provider" {
  type        = string
  default     = "externalmetrics"
  description = "The metrics provider to be used"
  
}

variable "use_tpl_files" {
  type        = bool
  default     = true
  description = "Whether to use .tpl files (true) or .json files (false) for templates"
}

# NRN Patch Configuration
variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}

