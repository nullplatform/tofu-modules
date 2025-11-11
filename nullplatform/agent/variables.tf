################################################################################
# Required Variables
################################################################################

variable "cluster_name" {
  description = "Name of the EKS cluster where the Nullplatform agent will be deployed"
  type        = string
}

variable "nrn" {
  description = "Nullplatform Resource Name - Unique identifier for Nullplatform resources"
  type        = string
}

variable "np_api_key" {
  description = "API key for authenticating with the Nullplatform API"
  type        = string
  sensitive   = true
}


variable "tags_selectors" {
  description = "Map of tags used to select and filter channels and agents"
  type        = map(string)
}

################################################################################
# Agent Configuration
################################################################################

variable "nullplatform_agent_helm_version" {
  description = "Version of the Nullplatform agent Helm chart to deploy"
  type        = string
  default     = "2.11.0"
}

variable "namespace" {
  description = "Kubernetes namespace where the Nullplatform agent will run"
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

variable "image_tag" {
  description = "Image tag to agent"
  type        = string
}

variable "aws_iam_role_arn" {
  description = "The ARN role to aws agent"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "aws" || var.aws_iam_role_arn != null
    error_message = "aws_iam_role_arn is required when cloud_provider is 'aws'."
  }
}

variable "cloud_provider" {
  description = "Cloud provider to use (aws, gcp or azure)"
  type        = string
  validation {
    condition     = contains(["aws", "gcp", "azure"], var.cloud_provider)
    error_message = "cloud_provider must be either 'aws' , 'gcp' or 'azure'."
  }
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
  description = "Git reference (branch, tag, or commit)"
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

#########Azure
variable "azure_client_id" {
  description = "Azure client ID for authentication"
  type        = string
  default     = null
}

variable "azure_client_secret" {
  description = "Azure client secret for authentication"
  type        = string
  default     = null
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = null
}

variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
  default     = null
}

variable "private_gateway_name" {
  description = "Private gateway name for Azure networking"
  type        = string
  default     = null
}

variable "private_hosted_zone_rg" {
  description = "Resource group for private hosted zone"
  type        = string
  default     = null
}

variable "public_gateway_name" {
  description = "Public gateway name for Azure networking"
  type        = string
  default     = null
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = null
}