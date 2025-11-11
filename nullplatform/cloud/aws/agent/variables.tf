################################################################################
# Required Variables
################################################################################

variable "cluster_name" {
  description = "Name of the EKS cluster where the nullplatform agent will be deployed"
  type        = string
}

variable "nrn" {
  description = "The Nullplatform Resource Name (NRN) —unique identifier for nullplatform resources"
  type        = string
}

variable "np_api_key" {
  description = "API key used to authenticate with the nullplatform API"
  type        = string
  sensitive   = true
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the AWS IAM OIDC provider for EKS service account authentication"
  type        = string
}

variable "tags_selectors" {
  description = "Map of tags used to select and filter channels and agents"
  type        = map(string)
}

################################################################################
# Agent Configuration
################################################################################

variable "nullplatform_agent_helm_version" {
  description = "Version of the nullplatform agent Helm chart to deploy"
  type        = string
  default     = "2.11.0"
}

variable "namespace" {
  description = "Kubernetes namespace where the nullplatform agent will run"
  type        = string
  default     = "nullplatform-tools"
}

variable "agent_repos_scope" {
  description = "Git repository URL containing agent scope configurations (format: repo#branch)"
  type        = string
  default     = "https://github.com/nullplatform/scopes.git#main"
}

variable "agent_repos_extra" {
  description = "List of additional Git repositories for extended agent configuration"
  type        = list(string)
  default     = []
}

variable "init_scripts" {
  description = "List of initialization scripts to execute during agent startup"
  type        = list(string)
  default     = []
}

################################################################################
# Template and Repository Configuration
################################################################################

variable "service_path" {
  description = "Path to the service directory within the repository structure"
  type        = string
  default     = "k8s"
}

variable "repo_path" {
  description = "Local filesystem path where the scope repository will be cloned"
  type        = string
  default     = "/root/.np/nullplatform/scopes"
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

################################################################################
# Action Specifications
################################################################################

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
    "kill-instances"
  ]
}

variable "service_spec_description" {
  description = "Description of the service specification"
  type        = string
  default     = "Docker containers on pods"
}

variable "service_spec_name" {
  description = "Name of the scope type"
  type        = string
  default     = "Containers"
}

################################################################################
# External Providers Configuration
################################################################################

variable "external_metrics_provider" {
  description = "Name of the external metrics provider for monitoring integration"
  type        = string
  default     = "externalmetrics"
}

variable "external_logging_provider" {
  description = "Name of the external logging provider for log aggregation"
  type        = string
  default     = "external"
}

################################################################################
# Override Configuration
################################################################################

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