################################################################################
# Required Variables
################################################################################

variable "cluster_name" {
  description = "Name of the EKS cluster where the nullplatform agent will be deployed"
  type        = string
}

variable "nrn" {
  description = "Nullplatform Resource Name - unique identifier for nullplatform resources"
  type        = string
}

variable "np_api_key" {
  description = "API key used to authenticate with the nullplatform API"
  type        = string
  sensitive   = true
}


variable "tags_selectors" {
  description = "Map of tags used to select and filter channels and agents"
  type        = map(string)
}

################################################################################
# Agent configuration
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
  description = "List of additional Git repositories used for extended agent configuration"
  type        = list(string)
  default     = []
}

variable "init_scripts" {
  description = "List of initialization scripts to execute during agent startup"
  type        = list(string)
  default     = []
}

variable "image_tag" {
  description = "Image tag for the agent container image"
  type        = string
}

variable "aws_iam_role_arn" {
  description = "ARN of the AWS IAM role assigned to the agent"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "aws" || var.aws_iam_role_arn != null
    error_message = "aws_iam_role_arn is required when cloud_provider is 'aws'."
  }
}

variable "cloud_provider" {
  description = "Cloud provider to use (aws, gcp, or azure)"
  type        = string
  validation {
    condition     = contains(["aws", "gcp", "azure"], var.cloud_provider)
    error_message = "cloud_provider must be either 'aws' , 'gcp', or 'azure'."
  }
}
################################################################################
# Template and repository configuration
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
###########
variable "git_ref" {
  type        = string
  default     = "main"
  description = "Git reference to use (branch, tag, or commit)"
}

variable "git_scope_path" {
  type        = string
  default     = "k8s"
  description = "Path within the repository for the specific scope (e.g., k8s, ecs)"
}

variable "git_repo" {
  type        = string
  default     = "nullplatform/scopes"
  description = "GitHub repository containing templates"
}
