# =============================================================================
# Common Variables (from common.tfvars)
# =============================================================================

variable "aws_region" {
  type        = string
  description = "AWS region for all resources"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile for authentication"
  default     = null
}

variable "organization" {
  type        = string
  description = "Nullplatform organization name"
}

variable "account" {
  type        = string
  description = "Nullplatform account name"
}

variable "domain_name" {
  type        = string
  description = "Domain name for DNS zones and certificates"
}

variable "np_api_key" {
  type        = string
  description = "Nullplatform API key for provider authentication"
  sensitive   = true
}

variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name"
}

variable "tags_selectors" {
  type        = map(string)
  description = "Tags selectors for agent channel filtering (shared with nullplatform-bindings)"
}

# =============================================================================
# VPC Variables
# =============================================================================

variable "vpc" {
  type = object({
    cidr_block      = string
    azs             = list(string)
    private_subnets = list(string)
    public_subnets  = list(string)
  })
  description = "VPC configuration including CIDR block, availability zones, and subnet CIDRs"
}

# =============================================================================
# EKS Variables
# =============================================================================

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "eks_instance_types" {
  type        = string
  description = "EC2 instance type for EKS managed node groups"
  default     = "t3.medium"
}

variable "eks_kubernetes_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
  default     = "1.32"
}

variable "endpoint_public_access" {
  type        = bool
  description = "Whether the EKS public API server endpoint is enabled"
  default     = true
}

variable "endpoint_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the public EKS API endpoint"
  default     = ["0.0.0.0/0"]
}

# =============================================================================
# Agent Variables
# =============================================================================

variable "agent_namespace" {
  type        = string
  description = "Kubernetes namespace where the nullplatform agent runs"
  default     = "nullplatform-tools"
}

variable "agent_cloud_provider" {
  type        = string
  description = "Cloud provider for the agent"
  default     = "aws"
}

variable "agent_dns_type" {
  type        = string
  description = "DNS type for the agent (external_dns for Istio, route53 for ACM/Ingress)"
  default     = "external_dns"
}

variable "agent_image_tag" {
  type        = string
  description = "Image tag for the agent container"
  default     = "aws"
}

variable "agent_use_account_slug" {
  type        = string
  description = "Flag to use account slug in resource naming (required for external_dns)"
}

variable "agent_image_pull_secrets" {
  type        = string
  description = "Image pull secrets configuration (required for external_dns)"
}

variable "agent_service_template" {
  type        = string
  description = "Path to service template for Istio (required for external_dns)"
}

variable "agent_initial_ingress_path" {
  type        = string
  description = "Path to initial ingress template for Istio (required for external_dns)"
}

variable "agent_blue_green_ingress_path" {
  type        = string
  description = "Path to blue-green ingress template for Istio (required for external_dns)"
}

# =============================================================================
# Base Module Variables
# =============================================================================

variable "k8s_provider" {
  type        = string
  description = "Kubernetes provider type"
  default     = "eks"
}

variable "gateway_enabled" {
  type        = bool
  description = "Enable public gateway (internet-facing load balancer)"
  default     = true
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Enable internal gateway (private load balancer)"
  default     = true
}

variable "gateways_enabled" {
  type        = bool
  description = "Enable gateways Helm chart"
  default     = true
}

variable "gateway_public_aws_name" {
  type        = string
  description = "Name for the public gateway AWS load balancer"
  default     = "k8s-nullplatform-internet-facing"
}

variable "gateway_internal_aws_name" {
  type        = string
  description = "Name for the internal gateway AWS load balancer"
  default     = "k8s-nullplatform-internal"
}

variable "prometheus_enabled" {
  type        = bool
  description = "Enable Prometheus metrics exporter in base module"
  default     = true
}
