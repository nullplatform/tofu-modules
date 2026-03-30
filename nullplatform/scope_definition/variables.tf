################################################################################
# Template Paths and Names
################################################################################

variable "repository_service_spec" {
  description = "repository of service spec"
  type        = string
  default     = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"

}

variable "repository_service_spec_branch" {
  description = "branch reference of service spec"
  type        = string
  default     = "main"

}

variable "repository_scope_template" {
  description = "repository of scope template"
  type        = string
  default     = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"

}


variable "repository_scope_template_branch" {
  description = "branch reference of scope template"
  type        = string
  default     = "main"

}

variable "repository_action_templates" {
  description = "repository of action template"
  type        = string
  default     = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"

}

variable "repository_action_templates_branch" {
  description = "branch reference of action template"
  type        = string
  default     = "main"

}

variable "service_path" {
  description = "Path within the repository where the service specification files are stored (e.g., 'services/api')"
  type        = string
  default     = "k8s"
}

variable "repo_path" {
  description = "Base path to the repository used as context for gomplate template rendering"
  type        = string
  default     = "/root/.np/nullplatform/scopes"
}

variable "action_spec_names" {
  description = "List of action specification template names to fetch and create for scope operations"
  type        = list(string)
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
    "kill-instances",
    "diagnose-deployment",
    "diagnose-scope"
  ]
}

################################################################################
# Service Specification Configuration
################################################################################

variable "service_spec_name" {
  description = "Name of the service that will be created from the specification template"
  type        = string
  default     = "Containers"
}

variable "service_spec_description" {
  description = "Description of the created service or associated scope type"
  type        = string
  default     = "Docker containers on pods"
}

################################################################################
# Nullplatform / Environment Context
################################################################################

variable "nrn" {
  description = "Unique NRN identifier of the environment or resource in nullplatform"
  type        = string
}

variable "np_api_key" {
  description = "Nullplatform API key used for executing local commands (e.g., 'np nrn patch')"
  type        = string
  sensitive   = true
}

################################################################################
# External Providers (Metrics / Logging)
################################################################################

variable "external_metrics_provider" {
  description = "Name of the external metrics provider for monitoring integration"
  type        = string
  default     = "externalmetrics"
}

variable "external_logging_provider" {
  description = "Name of the external log provider"
  type        = string
  default     = "external"
}

variable "create_scope_configuration" {
  type        = bool
  default     = false
  description = "Whether to fetch and apply scope-configuration.json.tpl from the template repo. Set to true only if the file exists for this scope."
}
