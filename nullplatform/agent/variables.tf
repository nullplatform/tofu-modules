################################################################################
# Required Variables
################################################################################

# API key for authenticating with the nullplatform API
variable "api_key" {
  description = "API key for authenticating with the nullplatform API"
  type        = string
  sensitive   = true
}

# Image tag for the agent container image
variable "image_tag" {
  # example: aws-0.10.0-nonroot
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

variable "agent_repo" {
  description = <<-EOT
    Git repositories (each with a ref) the agent clones for its legacy
    command-executor exec flow. Joined into a comma-separated AGENT_REPO
    value, no spaces. Empty when every scope uses worker_orchestrator instead.

    Example:
      agent_repo = [
        "https://github.com/nullplatform/scopes.git#v1.15.1",
        "https://github.com/nullplatform/services-s-3.git#v0.3.0",
      ]
  EOT
  type        = list(string)
  default     = []
}

################################################################################
# Agent configuration
################################################################################

# Override for the Helm release name. Defaults to nullplatform-agent
variable "release_name" {
  description = "Override for the Helm release name. Defaults to nullplatform-agent"
  type        = string
  default     = "nullplatform-agent"
}

# Override for the Kubernetes ServiceAccount name. Defaults to the chart's default (nullplatform-agent)
variable "service_account_name" {
  description = "Override for the Kubernetes ServiceAccount name created by the Helm chart"
  type        = string
  default     = "nullplatform-agent"
}

variable "worker_orchestrated_packages" {
  description = <<-EOT
    Package slugs whose worker-orchestrator (package-exec) pods should run
    under var.service_account_name (the same IRSA identity as the agent
    itself) and var.worker_memory_limit, via a per-package worker-container
    patch. Add a package's slug here whenever its worker needs to assume an
    AWS role, or needs more memory than the chart's own default (e.g. to run
    tofu/terraform); a worker for a package not listed here falls back to the
    namespace's default ServiceAccount and the chart's own memory default.

    This is separate from the "containers" scope's own k8s-deployment env
    vars (DNS_TYPE, DOMAIN, etc.), which remain specific to that package
    regardless of what's listed here.
  EOT
  type        = list(string)
  default     = ["containers"]
}

variable "worker_memory_limit" {
  description = "Memory limit for a worker-orchestrated package's pod (packages in var.worker_orchestrated_packages). The chart's own default is small enough to OOM mid-tofu-apply for packages that run real IaC tooling."
  type        = string
  default     = "2Gi"
}

# Version of the nullplatform agent Helm chart to deploy
variable "nullplatform_agent_helm_version" {
  # example: 2.37.0
  description = "No default: every install pins this deliberately — see VERSIONS.md. Version of the nullplatform agent Helm chart to deploy"
  type        = string
  # 2.37.0+ ships the worker orchestrator (patches, per-install isolation, idle

  validation {
    condition     = var.nullplatform_agent_helm_version != "" && !contains(["latest", "main", "master"], lower(var.nullplatform_agent_helm_version))
    error_message = "nullplatform_agent_helm_version must be a non-empty fixed version, not empty and not a moving reference."
  }
}

variable "worker" {
  description = <<-EOT
    Extra worker-orchestration config, merged on top of the module's own computed
    worker block: backend ("kubernetes" by default), allowedRegistries
    (["public.ecr.aws/nullplatform/*"] by default, so the platform's own scope
    images keep working), and a patch for the worker container (2Gi memory
    limit, the deploy/DNS env vars below, and a serviceAccountName that always
    mirrors service_account_name). allowedRegistries and patches set here are
    concatenated with (not replacing) the module defaults — add your own
    registries or an extra patch rather than having to repeat the defaults;
    set backend here to override it outright. Anything else — security, idleTTL
    (reap idle workers), the legacy defaults/rules/pins — passes through as-is.
    See the nullplatform-agent chart values (>= 2.37.0) for the full shape.
    null = nothing extra.

    Example:
      worker = {
        allowedRegistries = ["123456789012.dkr.ecr.us-east-1.amazonaws.com/your-org/*"]
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
}

variable "agent_traffic_manager_repository" {
  description = "Container image repository for the traffic manager. Defaults to the official nullplatform image; override to pull from a mirror. Matches the pattern nullplatform/base uses for its own images."
  type        = string
  default     = "public.ecr.aws/nullplatform/k8s-traffic-manager"
}

variable "agent_traffic_manager_tag" {
  # example: 1.8.0
  description = "No default: every install pins this deliberately — see VERSIONS.md. Image tag for the traffic manager, published to the agent as TRAFFIC_CONTAINER_IMAGE. Pinning this used to mean passing the whole image string through extra_envs; the registry lives here so only the tag is exposed. extra_envs still takes precedence for anyone who needs a digest or a mirrored path."
  type        = string

  validation {
    condition     = var.agent_traffic_manager_tag != "" && !contains(["latest", "main", "master"], lower(var.agent_traffic_manager_tag))
    error_message = "agent_traffic_manager_tag must be a non-empty fixed version, not empty and not a moving reference."
  }
}


# List of initialization scripts to execute during agent startup
variable "init_scripts" {
  description = "List of initialization scripts to execute during agent startup"
  type        = list(string)
  default     = []
}

# Container image repository for the agent. Defaults to the official nullplatform image.
variable "image_repository" {
  description = "Container image repository for the agent. Defaults to the official nullplatform image."
  type        = string
  default     = ""
}

# Flag to determine whether to use the account slug in resource naming
variable "use_account_slug" {
  description = "Flag to determine whether to use the account slug in resource naming"
  type        = string
  default     = ""
}

################################################################################
# AWS Configuration
################################################################################

# ARN of the AWS IAM role assigned to the agent (required when cloud_provider is 'aws')
variable "aws_iam_role_arn" {
  description = "ARN of the AWS IAM role assigned to the agent"
  type        = string
  default     = ""
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
  description = "Name of the private/internal gateway used for routing"
  type        = string
  default     = "gateway-private"
}

# Name of the public gateway used for routing
variable "public_gateway_name" {
  description = "Name of the public gateway used for routing"
  type        = string
  default     = "gateway-public"
}

################################################################################
# DNS and Domain Configuration
################################################################################

# Type of DNS Provider (azure, aws, gcp, or external_dns)
variable "dns_type" {
  description = "Type of DNS Provider, ej: azure, route53, or external_dns"
  type        = string
  default     = ""
}

# Base domain name used across resources
variable "domain" {
  description = "Base domain name used across resources"
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
  default     = ""
}

################################################################################
# Ingress / Networking Configuration
################################################################################

# Scope service template to use for deployment (required when extra_envs.INGRESS_TYPE is 'istio')
variable "service_template" {
  description = "Specifies the name or reference of the scope service template to be used for deployment. Required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio-compatible template instead."
  type        = string
  default     = ""
}

# Initial ingress path used on first deploy (required when extra_envs.INGRESS_TYPE is 'istio')
variable "initial_ingress_path" {
  description = "Defines the initial ingress path used when deploying the application for the first time. Required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio HTTPRoute template instead."
  type        = string
  default     = ""
}

# Blue-green ingress path used to route traffic to the new version (required when extra_envs.INGRESS_TYPE is 'istio')
variable "blue_green_ingress_path" {
  description = "Specifies the ingress path used for blue-green deployments to route traffic to the new version. Required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio HTTPRoute template instead."
  type        = string
  default     = ""
}

# Additional environment variables to pass to the agent
variable "extra_envs" {
  description = "Additional environment variables to pass to the agent"
  type        = map(string)
  default     = {}
}
