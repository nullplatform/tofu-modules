variable "nullplatform-agent-helm-version" {
  description = "Helm chart version for the Nullplatform agent"
  type        = string
  default     = "2.11.0"
}

variable "agent_repos_scope" {
  description = "Git repository URL for agent scopes configuration"
  type        = string
  default     = "https://github.com/nullplatform/scopes.git#main"
}

variable "agent_repos_extra" {
  description = "Additional repositories for the agent configuration"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to identifier agent"
  type        = string
}

variable "init_scripts" {
  description = "List of initialization scripts to run"
  type        = list(string)
  default     = []
}

variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to agent run"
  type        = string
  default     = "nullplatform-tools"
}

# Template Configuration
variable "service_path" {
  type        = string
  default     = "k8s"
  description = "Service path within the repository"
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
  default     = "beta"
  description = "Git reference (branch, tag, or commit)"
}

variable "environment_tag" {}

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
  description = "External metrics provider name"
}

variable "external_logging_provider" {
  type        = string
  default     = "external"
  description = "External logging provider name"
}

variable "aws_iam_openid_connect_provider_arn" {}