################################################################################
# Repository Configuration
################################################################################

# Name of the GitHub repository where templates are stored.
# Format must be "owner/repo" (e.g., "nullplatform/service-definitions").
variable "github_repo_name" {
  description = "Name of the GitHub repository in 'owner/repo' format (e.g., 'nullplatform/service-definitions')."
  type        = string
  default     = "nullplatform/scopes"
}

# Reference (branch, tag, or commit SHA) to use when fetching templates.
variable "github_ref" {
  description = "Branch, tag, or commit SHA of the Git repository to read templates from."
  type        = string
  default     = "beta"
}

# Full repository URL (HTTPS or SSH). Used by the git clone command.
variable "github_repo_url" {
  description = "Git repository URL (HTTPS or SSH format) used to clone the templates."
  type        = string
  default     = "https://github.com/nullplatform/scopes.git"
}

################################################################################
# Template Paths and Names
################################################################################

# Path within the repository where service specification files are located.
# Example: "services/api" or "k8s"
variable "service_path" {
  description = "Path within the repository where the service specification files are stored (e.g., 'services/api')."
  type        = string
  default     = "k8s"
}

# Local repository base path used as context for gomplate rendering.
variable "repo_path" {
  description = "Base path to the repository used as context for gomplate template rendering."
  type        = string
  default     = "/root/.np/nullplatform/scopes"
}

# List of action specification template names to be processed and created for scope operations.
variable "action_spec_names" {
  description = "List of action specification template names to fetch and create for scope operations."
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
    "kill-instances"
  ]
}

################################################################################
# Service Specification Configuration
################################################################################

# Name of the service specification created from the template.
variable "service_spec_name" {
  description = "Name of the service that will be created from the specification template."
  type        = string
  default     = "Containers"
}

# Description of the created service or associated scope type.
variable "service_spec_description" {
  description = "Description of the created service or associated scope type."
  type        = string
  default     = "Docker containers on pods"
}

################################################################################
# Nullplatform / Environment Context
################################################################################

# Unique NRN identifier of the environment or resource in Nullplatform.
variable "nrn" {
  description = "Unique NRN identifier of the environment or resource in Nullplatform."
  type        = string
}

# Nullplatform API key used to run local commands such as 'np nrn patch'.
variable "np_api_key" {
  description = "Nullplatform API key used for executing local commands (e.g., 'np nrn patch')."
  type        = string
  sensitive   = true
}

################################################################################
# External Providers (Metrics / Logging)
################################################################################

# External metrics provider name for monitoring integrations.
variable "metrics_provider" {
  description = "Name of the external metrics provider for monitoring integration."
  type        = string
  default     = "externalmetrics"
}

# External log provider (e.g., 'cloudwatch', 'elastic').
variable "logging_provider" {
  description = "Name of the external log provider (e.g., 'cloudwatch', 'elastic')."
  type        = string
  default     = "external"
}
