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
}

variable "cloud_provider" {
  description = "Cloud provider to use (aws, gcp or azure)"
  type        = string
}

variable "private_hosted_zone_rg" {
  description = ""
  type = string
  default = null
}
variable "private_gateway_name" {
  description = ""
  type = string
  default = null
}
variable "public_gateway_name" {
  description = ""
  type = string
  default = null
}
variable "azure_resource_group" {
  description = ""
  type = string
  default = null
}
variable "azure_subscription_id" {
  description = ""
  type = string
  default = null
}
variable "azure_client_secret" {
  description = ""
  type = string
  default = null
}
variable "azure_client_id" {
  description = ""
  type = string
  default = null
}
variable "azure_tenant_id" {
  description = ""
  type = string
  default = null
}