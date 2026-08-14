################################################################################
# Required Variables
################################################################################

# API key for authenticating with the nullplatform API
variable "api_key" {
  description = "API key for authenticating with the nullplatform API"
  type        = string
  sensitive   = true
}

# Name of the Kubernetes cluster where the nullplatform agent will be deployed
variable "cluster_name" {
  description = "Name of the Kubernetes cluster where the nullplatform agent will be deployed"
  type        = string
}

# Image tag for the agent container image
variable "image_tag" {
  description = "Image tag for the agent container image"
  type        = string
}

# Cloud provider the cluster runs on
variable "cloud_provider" {
  description = "Cloud provider to use ('aws', 'gcp', 'azure', or 'oci')"
  type        = string
  validation {
    condition     = contains(["aws", "gcp", "azure", "oci"], var.cloud_provider)
    error_message = "cloud_provider must be either 'aws' , 'gcp', 'oci' or 'azure'."
  }
}

# Map of tags used to select and filter channels and agents
variable "tags_selectors" {
  description = "Map of tags used to select and filter channels and agents"
  type        = map(string)
}

################################################################################
# Agent configuration
################################################################################

# Override for the Helm release name. Defaults to nullplatform-agent
variable "release_name" {
  description = "Override for the Helm release name. Defaults to nullplatform-agent"
  type        = string
  default     = "nullplatform-agent"
  nullable    = false
}

# Override for the Kubernetes ServiceAccount name. Defaults to the chart's default (nullplatform-agent)
variable "service_account_name" {
  description = "Override for the Kubernetes ServiceAccount name created by the Helm chart"
  type        = string
  default     = ""
  nullable    = false
}

# Version of the nullplatform agent Helm chart to deploy
variable "nullplatform_agent_helm_version" {
  description = "Version of the nullplatform agent Helm chart to deploy"
  type        = string
  # 2.37.0+ ships the worker orchestrator (patches, per-install isolation, idle
  # reaper, insecure default).
  default = "2.37.0"
}

variable "worker" {
  description = <<-EOT
    Worker-orchestration config, merged into the agent chart's `worker` block:
    backend, security, allowedRegistries (deny-by-default registry guardrail),
    patches (standard k8s patching of workers — the preferred way to shape them),
    idleTTL (reap idle workers), and the legacy defaults/rules/pins. See the
    nullplatform-agent chart values (>= 2.37.0) for the full shape. null = chart
    defaults.

    Example:
      worker = {
        allowedRegistries = ["public.ecr.aws/your-org/*"]
        patches           = [{ target = { package = "my-pkg" }, merge = { spec = { serviceAccountName = "np-agent-sa" } } }]
        idleTTL           = "30m"
      }
  EOT
  type        = any
  default     = null
}

# Kubernetes namespace where the nullplatform agent will run
variable "namespace" {
  description = "Kubernetes namespace where the nullplatform agent will run"
  type        = string
  default     = "nullplatform-tools"
  nullable    = false
}

# Git repository URL containing agent scope configurations (format: repo#branch)
variable "agent_repos_scope" {
  description = "Git repository URL containing agent scope configurations (format: repo#branch)"
  type        = string
  default     = "https://github.com/nullplatform/scopes.git#main"
  nullable    = false
}

# List of additional Git repositories used for extended agent configuration
variable "agent_repos_extra" {
  description = "List of additional Git repositories used for extended agent configuration"
  type        = list(string)
  default     = []
  nullable    = false
}

# List of initialization scripts to execute during agent startup
variable "init_scripts" {
  description = "List of initialization scripts to execute during agent startup"
  type        = list(string)
  default     = []
  nullable    = false
}

# Container image repository for the agent. Defaults to the official nullplatform image.
variable "image_repository" {
  description = "Container image repository for the agent. Defaults to the official nullplatform image."
  type        = string
  default     = ""
  nullable    = false
}

# Flag to determine whether to use the account slug in resource naming
variable "use_account_slug" {
  description = "Flag to determine whether to use the account slug in resource naming"
  type        = string
  default     = ""
  nullable    = false
}

################################################################################
# AWS Configuration
################################################################################

# ARN of the AWS IAM role assigned to the agent (required when cloud_provider is 'aws')
variable "aws_iam_role_arn" {
  description = "ARN of the AWS IAM role assigned to the agent"
  type        = string
  default     = ""
  nullable    = false
}

################################################################################
# Azure Configuration
################################################################################

# Azure client ID for authentication (required when cloud_provider is 'azure')
variable "azure_client_id" {
  description = "Azure client ID for authentication"
  type        = string
  default     = null
}

# Azure client secret for authentication (required when cloud_provider is 'azure')
variable "azure_client_secret" {
  description = "Azure client secret for authentication"
  type        = string
  default     = null
  sensitive   = true
}

# Azure subscription ID (required when cloud_provider is 'azure')
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = null
}

# Azure resource group name (required when cloud_provider is 'azure')
variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
  default     = null
}

# Resource group for private hosted zone (required when cloud_provider is 'azure')
variable "private_hosted_zone_rg" {
  description = "Resource group for private hosted zone"
  type        = string
  default     = null
}

# Azure tenant ID (required when cloud_provider is 'azure')
variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = null
}

################################################################################
# Gateway Configuration
################################################################################

# Name of the private/internal gateway used for routing
variable "private_gateway_name" {
  description = "Name of the private/internal gateway used for routing. Must match the Gateway the cluster actually has: nullplatform/base hardcodes the private Gateway as 'gateway-private' (templates/nullplatform_base_values.tmpl.yaml), while the k8s scope's own fallback is 'gateway-internal' — a mismatch produces HTTPRoutes with an unresolvable parentRef and deploys that die in verify_networking_reconciliation"
  type        = string
  default     = "gateway-private"
  nullable    = false
}

# Name of the public gateway used for routing
variable "public_gateway_name" {
  description = "Name of the public gateway used for routing. Must match nullplatform/base's gateway_public_name, which is overridable and documented to be overridden (e.g. 'internet-facing' on AKS). If base was overridden and this is left at the default, HTTPRoutes get an unresolvable parentRef and the Azure DNS record manager is handed a gateway name that does not exist"
  type        = string
  default     = "gateway-public"
  nullable    = false
}

################################################################################
# DNS and Domain Configuration
################################################################################

# Type of DNS Provider (azure, aws, gcp, or external_dns)
variable "dns_type" {
  description = "Type of DNS Provider, ej: azure, route53, or external_dns"
  type        = string
  default     = ""
  nullable    = false
}

# Base domain name used across resources
variable "domain" {
  description = "Base domain name used across resources"
  type        = string
  default     = ""
  nullable    = false
}

################################################################################
# Image Configuration
################################################################################

# Image pull secrets configuration
variable "image_pull_secrets" {
  description = "Image pull secrets configuration"
  type        = string
  default     = ""
  nullable    = false
}

################################################################################
# Ingress / Networking Configuration
################################################################################

# Scope service template to use for deployment (required when extra_envs.INGRESS_TYPE is 'istio')
variable "service_template" {
  description = "Specifies the name or reference of the scope service template to be used for deployment. Leave empty to use the default from the scope type's own values.yaml. Override it when the scope type's default does not match the cluster's ingress: scopes/k8s defaults to an AWS ALB Ingress template, so a GKE or AKS cluster running the k8s scope type needs all three of service_template, initial_ingress_path and blue_green_ingress_path pointed at Istio HTTPRoute templates, or deployments come up with no working route and no error. The scopes/azure and scopes/azure-aro scope types already set them and need no override. All three must be set together or all left empty: finalize renders INITIAL_INGRESS_PATH and switch-traffic renders BLUE_GREEN_INGRESS_PATH into the same slot, so a half-override breaks blue-green mid-deploy"
  type        = string
  default     = ""
  nullable    = false
}

# Initial ingress path used on first deploy (required when extra_envs.INGRESS_TYPE is 'istio')
variable "initial_ingress_path" {
  description = "Defines the initial ingress path used when deploying the application for the first time. Leave empty to use the default from the scope type's own values.yaml. Override it when the scope type's default does not match the cluster's ingress: scopes/k8s defaults to an AWS ALB Ingress template, so a GKE or AKS cluster running the k8s scope type needs all three of service_template, initial_ingress_path and blue_green_ingress_path pointed at Istio HTTPRoute templates, or deployments come up with no working route and no error. The scopes/azure and scopes/azure-aro scope types already set them and need no override. All three must be set together or all left empty: finalize renders INITIAL_INGRESS_PATH and switch-traffic renders BLUE_GREEN_INGRESS_PATH into the same slot, so a half-override breaks blue-green mid-deploy"
  type        = string
  default     = ""
  nullable    = false
}

# Blue-green ingress path used to route traffic to the new version (required when extra_envs.INGRESS_TYPE is 'istio')
variable "blue_green_ingress_path" {
  description = "Specifies the ingress path used for blue-green deployments to route traffic to the new version. Leave empty to use the default from the scope type's own values.yaml. Override it when the scope type's default does not match the cluster's ingress: scopes/k8s defaults to an AWS ALB Ingress template, so a GKE or AKS cluster running the k8s scope type needs all three of service_template, initial_ingress_path and blue_green_ingress_path pointed at Istio HTTPRoute templates, or deployments come up with no working route and no error. The scopes/azure and scopes/azure-aro scope types already set them and need no override. All three must be set together or all left empty: finalize renders INITIAL_INGRESS_PATH and switch-traffic renders BLUE_GREEN_INGRESS_PATH into the same slot, so a half-override breaks blue-green mid-deploy"
  type        = string
  default     = ""
  nullable    = false
}

# Additional environment variables to pass to the agent
variable "extra_envs" {
  description = "Additional environment variables to pass to the agent"
  type        = map(string)
  default     = {}
  nullable    = false
}

################################################################################
# Deprecated inputs
#
# Removed in v6.14.0, restored here because removing a declared input is a
# breaking change and 6.x is the non-breaking line: OpenTofu rejects an argument
# for a variable that no longer exists, so every consumer passing these failed at
# init the moment they bumped the module ref. They are intentionally unused —
# `nrn` never was consumed (the agent resolves its own scope from the API key) and
# PRIVATE_DOMAIN is confirmed dead in nullplatform/scopes. Drop them on the next
# major, with a BREAKING CHANGE footer.
################################################################################

# tflint-ignore: terraform_unused_declarations
variable "nrn" {
  description = "DEPRECATED, accepted for compatibility and ignored. Nullplatform Resource Name; the agent resolves its own scope from the API key, so this module never consumed the value"
  type        = string
  default     = ""
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "private_domain" {
  description = "DEPRECATED, accepted for compatibility and ignored. Previously rendered as the PRIVATE_DOMAIN env var for gcp and oci, which nothing in nullplatform/scopes reads"
  type        = string
  default     = ""
  nullable    = false
}
