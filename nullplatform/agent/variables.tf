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
  description = "Docker image tag for the Nullplatform agent container"
  type        = string
}

variable "cloud_provider" {
  description = "Cloud provider where the infrastructure is deployed. Valid values: aws, azure, gcp"
  type        = string
  validation {
    condition     = contains(["aws", "azure", "gcp"], var.cloud_provider)
    error_message = "cloud_provider must be either 'aws', 'azure' or 'gcp'."
  }
}

################################################################################
# AWS Configuration
# Required when cloud_provider = "aws"
################################################################################

variable "aws_iam_role_arn" {
  description = "ARN of the IAM role to be used by the Nullplatform agent in AWS. Required when cloud_provider is 'aws'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "aws" || var.aws_iam_role_arn != null
    error_message = "aws_iam_role_arn is required when cloud_provider is 'aws'."
  }
}

################################################################################
# Azure Configuration
# Required when cloud_provider = "azure"
################################################################################

variable "private_hosted_zone_rg" {
  description = "Azure resource group name where the private DNS zone is located. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.private_hosted_zone_rg != null
    error_message = "private_hosted_zone_rg is required when cloud_provider is 'azure'."
  }
}

variable "private_gateway_name" {
  description = "Name of the private Application Gateway in Azure. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.private_gateway_name != null
    error_message = "private_gateway_name is required when cloud_provider is 'azure'."
  }
}

variable "public_gateway_name" {
  description = "Name of the public Application Gateway in Azure. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.public_gateway_name != null
    error_message = "public_gateway_name is required when cloud_provider is 'azure'."
  }
}

variable "azure_resource_group" {
  description = "Azure resource group name where the Nullplatform agent resources will be created. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.azure_resource_group != null
    error_message = "azure_resource_group is required when cloud_provider is 'azure'."
  }
}

variable "azure_subscription_id" {
  description = "Azure subscription ID where the resources are deployed. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.azure_subscription_id != null
    error_message = "azure_subscription_id is required when cloud_provider is 'azure'."
  }
}

variable "azure_client_secret" {
  description = "Azure service principal client secret for authentication. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition     = var.cloud_provider != "azure" || var.azure_client_secret != null
    error_message = "azure_client_secret is required when cloud_provider is 'azure'."
  }
}

variable "azure_client_id" {
  description = "Azure service principal client ID (Application ID) for authentication. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.azure_client_id != null
    error_message = "azure_client_id is required when cloud_provider is 'azure'."
  }
}

variable "azure_tenant_id" {
  description = "Azure Active Directory tenant ID where the service principal is registered. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.azure_tenant_id != null
    error_message = "azure_tenant_id is required when cloud_provider is 'azure'."
  }
}

variable "dns_type" {
  description = "Type of DNS configuration to use in Azure (e.g., public, private). Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.dns_type != null
    error_message = "dns_type is required when cloud_provider is 'azure'."
  }
}

variable "domain" {
  description = "Domain name to be used for DNS configuration in Azure. Required when cloud_provider is 'azure'"
  type        = string
  default     = null
  validation {
    condition     = var.cloud_provider != "azure" || var.domain != null
    error_message = "domain is required when cloud_provider is 'azure'."
  }
}

################################################################################
# GCP Configuration
# Add GCP-specific variables here if needed in the future
################################################################################