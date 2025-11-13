################################################################################
# Required Variables
################################################################################

# Name of the EKS cluster where the nullplatform agent will be deployed
variable "cluster_name" {
  description = "Name of the EKS cluster where the nullplatform agent will be deployed"
  type        = string
}

# Nullplatform Resource Name - unique identifier for nullplatform resources
variable "nrn" {
  description = "Nullplatform Resource Name - unique identifier for nullplatform resources"
  type        = string
}

# Map of tags used to select and filter channels and agents
variable "tags_selectors" {
  description = "Map of tags used to select and filter channels and agents"
  type        = map(string)
}

################################################################################
# Agent configuration
################################################################################

# Version of the nullplatform agent Helm chart to deploy
variable "nullplatform_agent_helm_version" {
  description = "Version of the nullplatform agent Helm chart to deploy"
  type        = string
  default     = "2.11.0"
}

# Kubernetes namespace where the nullplatform agent will run
variable "namespace" {
  description = "Kubernetes namespace where the nullplatform agent will run"
  type        = string
  default     = "nullplatform-tools"
}

# Git repository URL containing agent scope configurations (format: repo#branch)
variable "agent_repos_scope" {
  description = "Git repository URL containing agent scope configurations (format: repo#branch)"
  type        = string
  default     = "https://github.com/nullplatform/scopes.git#main"
}

# List of additional Git repositories used for extended agent configuration
variable "agent_repos_extra" {
  description = "List of additional Git repositories used for extended agent configuration"
  type        = list(string)
  default     = []
}

# List of initialization scripts to execute during agent startup
variable "init_scripts" {
  description = "List of initialization scripts to execute during agent startup"
  type        = list(string)
  default     = []
}

# Image tag for the agent container image
variable "image_tag" {
  description = "Image tag for the agent container image"
  type        = string
}

# ARN of the AWS IAM role assigned to the agent (required when cloud_provider is 'aws')
variable "aws_iam_role_arn" {
  description = "ARN of the AWS IAM role assigned to the agent"
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "aws" || var.aws_iam_role_arn != ""
    error_message = "aws_iam_role_arn is required when cloud_provider is 'aws'."
  }
}

# Cloud provider to use (aws, gcp, or azure)
variable "cloud_provider" {
  description = "Cloud provider to use (aws, gcp, or azure)"
  type        = string
  validation {
    condition     = contains(["aws", "gcp", "azure"], var.cloud_provider)
    error_message = "cloud_provider must be either 'aws' , 'gcp', or 'azure'."
  }
}

################################################################################
# Azure Configuration
################################################################################

# Azure client ID for authentication (required when cloud_provider is 'azure')
variable "azure_client_id" {
  description = "Azure client ID for authentication"
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "azure" || var.azure_client_id != null
    error_message = "azure_client_id is required when cloud_provider is 'azure'"
  }
}

# Azure client secret for authentication (required when cloud_provider is 'azure')
variable "azure_client_secret" {
  description = "Azure client secret for authentication"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.cloud_provider != "azure" || var.azure_client_secret != null
    error_message = "azure_client_secret is required when cloud_provider is 'azure'"
  }
}

# Azure subscription ID (required when cloud_provider is 'azure')
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "azure" || var.azure_subscription_id != null
    error_message = "azure_subscription_id is required when cloud_provider is 'azure'"
  }
}

# Azure resource group name (required when cloud_provider is 'azure')
variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "azure" || var.azure_resource_group != null
    error_message = "azure_resource_group is required when cloud_provider is 'azure'"
  }
}

# Private gateway name for Azure networking (required when cloud_provider is 'azure')
variable "private_gateway_name" {
  description = "Private gateway name for Azure networking"
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "azure" || var.private_gateway_name != null
    error_message = "private_gateway_name is required when cloud_provider is 'azure'"
  }
}

# Resource group for private hosted zone (required when cloud_provider is 'azure')
variable "private_hosted_zone_rg" {
  description = "Resource group for private hosted zone"
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "azure" || var.private_hosted_zone_rg != null
    error_message = "private_hosted_zone_rg is required when cloud_provider is 'azure'"
  }
}

# Public gateway name for Azure networking (required when cloud_provider is 'azure')
variable "public_gateway_name" {
  description = "Public gateway name for Azure networking"
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "azure" || var.public_gateway_name != null
    error_message = "public_gateway_name is required when cloud_provider is 'azure'"
  }
}

# Azure tenant ID (required when cloud_provider is 'azure')
variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "azure" || var.azure_tenant_id != null
    error_message = "azure_tenant_id is required when cloud_provider is 'azure'"
  }
}

################################################################################
# DNS and Domain Configuration
################################################################################

# Type of DNS Provider (azure, aws, gcp, or external_dns)
variable "dns_type" {
  description = "Type of DNS Provider, ej: azure, aws, gcp, or external_dns"
  type        = string
  default     = ""
}

# Base domain name used across resources (required when cloud_provider is 'azure')
variable "domain" {
  description = "Base domain name used across resources"
  type        = string
  default     = ""
}

# Flag to determine whether to use account slug in resource naming (required when cloud_provider is 'azure')
variable "use_account_slug" {
  description = "Flag to determine whether to use account slug in resource naming"
  type        = string
  default     = ""
}

################################################################################
# Image Configuration
################################################################################

# Image pull secrets configuration
variable "image_pull_secrets" {
  description = "Image pull secrets configuration"
  type        = string
  default = ""
}

variable "service_template" {
  description = "Specifies the name or reference of the scope service template to be used for deployment."
  type        = string
  default = ""
}

variable "initial_ingress_path" {
  description = "Defines the initial ingress path used when deploying the application for the first time."
  type        = string
  default = ""
}

variable "blue_green_ingress_path" {
  description = "Specifies the ingress path used for blue-green deployments to route traffic to the new version."
  type        = string
  default = ""
}