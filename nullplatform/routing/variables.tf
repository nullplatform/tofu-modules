variable "nullplatform_routing_helm_version" {
  description = "Helm chart version for the nullplatform routing chart."
  type        = string
  default     = "1.0.0"
}

variable "nullplatform_routing_chart_path" {
  description = "Local filesystem path to the nullplatform-routing chart. When set, overrides the Helm registry (use for local development/testing)."
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Kubernetes namespace where the routing chart will be installed."
  type        = string
  default     = "nullplatform-tools"
}

variable "gateway_namespace" {
  description = "Kubernetes namespace for gateway resources."
  type        = string
  default     = "gateways"
}

variable "k8s_provider" {
  type        = string
  description = "Cloud provider (eks, gke, aks, oke and aro)."
  validation {
    condition     = contains(["eks", "gke", "aks", "oke", "aro"], var.k8s_provider)
    error_message = "k8s_provider must be one of: eks, gke, aks, oke and aro"
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region where resources will be deployed."
  default     = "us-east-1"
}

variable "install_gateway_v2_crd" {
  type        = bool
  description = "Install Gateway API v2 CRDs."
  default     = false
}

############################################
# Gateway
############################################

variable "gateway_enabled" {
  type        = bool
  description = "Enable the HTTP gateway."
  default     = false
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Enable the internal (private) gateway."
  default     = true
}

variable "gateway_public_enabled" {
  type        = bool
  description = "Enable the public gateway."
  default     = true
}

variable "internal_azure_load_balancer_subnet" {
  description = "The name of the subnet to use in azure private load balancer."
  type        = string
  default     = "load_balancer"
}

variable "gateway_use_cluster_ip" {
  type    = bool
  default = false
}

variable "gateway_public_aws_dns_name" {
  type    = string
  default = ""
}

variable "gateway_private_aws_dns_name" {
  type    = string
  default = ""
}

variable "gateway_public_aws_name" {
  type        = string
  description = "Name of public gateway in AWS."
  default     = "k8s-nullplatform-internet-facing"
}

variable "gateway_internal_aws_name" {
  type        = string
  description = "Name of private gateway in AWS."
  default     = "k8s-nullplatform-internal"
}

############################################
# Gateway Security Resource IDs
############################################

variable "gateway_public_aws_security_group_id" {
  type        = string
  description = "AWS security group ID for the public gateway. Output from infrastructure/aws/security module."
  default     = ""
}

variable "gateway_private_aws_security_group_id" {
  type        = string
  description = "AWS security group ID for the private gateway. Output from infrastructure/aws/security module."
  default     = ""
}

variable "gateway_public_azure_nsg_id" {
  type        = string
  description = "Azure NSG ID for the public gateway. Output from infrastructure/azure/security module."
  default     = ""
}

variable "gateway_private_azure_nsg_id" {
  type        = string
  description = "Azure NSG ID for the private gateway. Output from infrastructure/azure/security module."
  default     = ""
}

variable "gateway_public_gcp_firewall_name" {
  type        = string
  description = "GCP firewall rule name for the public gateway. Output from infrastructure/gcp/security module."
  default     = ""
}

variable "gateway_private_gcp_firewall_name" {
  type        = string
  description = "GCP firewall rule name for the private gateway. Output from infrastructure/gcp/security module."
  default     = ""
}

variable "gateway_public_oci_security_list_management_mode" {
  type        = string
  description = "OCI Load Balancer security list management mode for the public gateway."
  default     = "All"
}

variable "gateway_private_oci_security_list_management_mode" {
  type        = string
  description = "OCI Load Balancer security list management mode for the private gateway."
  default     = "All"
}

############################################
# Ingress Controller
############################################

variable "ingressControllers" {
  description = "Configuration for public and private IngressControllers."
  type = object({
    public = object({
      name    = string
      enabled = bool
      scope   = string
      domain  = string
    })
    private = object({
      name    = string
      enabled = bool
      scope   = string
      domain  = string
    })
  })

  default = {
    public = {
      name    = "internet-facing"
      enabled = false
      scope   = "External"
      domain  = ""
    }
    private = {
      name    = "internal"
      enabled = false
      scope   = "Internal"
      domain  = ""
    }
  }
}

############################################
# Gateway API / Gateways
############################################

variable "gateways_enabled" {
  type        = bool
  description = "Enable gateway resources (Helm chart)."
  default     = true
}

variable "gateway_api_enabled" {
  type        = bool
  description = "Enable the Gateway API."
  default     = false
}

variable "gateway_api_crds_install" {
  type        = bool
  description = "Install Gateway API CRDs."
  default     = false
}