variable "nullplatform_agent_helm_version" {
  description = "Helm chart version for the nullplatform agent"
  type        = string
  default     = "2.14.0"
}

variable "agent_repos_scope" {
  description = "Git repository URL for the agent scope configuration"
  type        = string
  default     = "https://github.com/nullplatform/scopes.git#ftc"
}

variable "agent_repos_extra" {
  description = "List of additional repositories for the agent configuration"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to identify the agent"
  type        = string
}

variable "init_scripts" {
  description = "List of initialization scripts to run"
  type        = list(string)
  default     = []
}

variable "nrn" {
  description = "The Nullplatform Resource Name (NRN)"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace where the agent runs"
  type        = string
  default     = "nullplatform-tools"
}

# Template Configuration
variable "service_path" {
  type        = string
  default     = "k8s"
  description = "Path to the service directory within the repository"
}

variable "repo_path" {
  type        = string
  default     = "/root/.np/nullplatform/scopes"
  description = "Local path to the repository containing templates"
}

variable "github_repo_url" {
  type        = string
  default     = "https://github.com/nullplatform/scopes"
  description = "GitHub repository URL containing templates"
}

variable "github_ref" {
  type        = string
  default     = "ftc"
  description = "Git reference to use (branch, tag, or commit)"
}

################################################################################
# Scope Definition Module Variables
################################################################################

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

# NRN Patch Configuration
variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}

variable "external_metrics_provider" {
  type        = string
  default     = "externalmetrics"
  description = "Name of the external metrics provider"
}

variable "external_logging_provider" {
  type        = string
  default     = "external"
  description = "Name of the external logging provider"
}

variable "environment_tag" {
  description = "Environment tag used to identify and filter agent resources"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file used for Kubernetes cluster access"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes context name to use from the kubeconfig file"
  type        = string
  default     = null
}