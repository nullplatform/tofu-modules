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
  # 2.37.0+ ships the worker orchestrator.
  default  = "2.37.0"
  nullable = false
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

# Whether the Helm release creates the namespace
variable "create_namespace" {
  description = "Create the namespace if it does not exist. Leave true unless another module already owns it: nullplatform/base declares the same namespace with Helm ownership metadata, so with no ordering edge between the two whichever applies second fails."
  type        = bool
  default     = true
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
  description = "Name of the private/internal gateway used for routing. Must match the Gateway the cluster actually has: nullplatform/base hardcodes 'gateway-private', and a mismatch produces HTTPRoutes with an unresolvable parentRef that die in verify_networking_reconciliation."
  type        = string
  default     = "gateway-private"
  nullable    = false
}

# Name of the public gateway used for routing
variable "public_gateway_name" {
  description = "Name of the public gateway used for routing. Must match nullplatform/base's gateway_public_name, which is commonly overridden (e.g. 'internet-facing' on AKS); leaving this at the default when base was overridden breaks HTTPRoute routing and Azure DNS records."
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

# Ingress flavour the k8s scope type runs on
variable "ingress_type" {
  description = "Ingress flavour of the cluster, for the `k8s` scope type only: 'alb' (default) or 'istio'. 'istio' fills service_template, initial_ingress_path and blue_green_ingress_path with the Istio HTTPRoute templates and renders INGRESS_TYPE=istio; set it when running the `k8s` scope type without an AWS ALB controller (GKE, or AKS not on the dedicated `azure` scope type), whose ALB Ingress default yields a deploy with no working route and no error. 'alb' keeps today's behaviour: the three paths stay empty so the scope type's own values.yaml decides, and INGRESS_TYPE is not rendered — services-endpoint-exposer ships only workflows/istio and would break on 'alb'. Explicit template paths always win over this variable."
  type        = string
  default     = "alb"
  nullable    = false
  validation {
    condition     = contains(["alb", "istio"], var.ingress_type)
    error_message = "ingress_type must be either 'alb' or 'istio'."
  }
}

# Scope service template to use for deployment
variable "service_template" {
  description = "Scope service template path. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress_type for the Istio preset."
  type        = string
  default     = ""
  nullable    = false
}

# Initial ingress path used on first deploy
variable "initial_ingress_path" {
  description = "Ingress template path for the initial deploy. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress_type for the Istio preset."
  type        = string
  default     = ""
  nullable    = false
}

# Blue-green ingress path used to route traffic to the new version
variable "blue_green_ingress_path" {
  description = "Ingress template path for the blue-green traffic switch. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress_type for the Istio preset."
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
# Restored: OpenTofu rejects an argument for a variable that does not exist, so
# removing them in v6.14.0 broke every consumer passing them. Intentionally
# unused. Drop them on the next major, with a BREAKING CHANGE footer.
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
