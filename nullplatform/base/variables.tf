variable "nullplatform_base_helm_version" {
  description = "Helm chart version for the nullplatform base."
  type        = string
  default     = "2.40.0"
}

variable "namespace" {
  description = "Kubernetes namespace where the agent runs."
  type        = string
  default     = "nullplatform-tools"
}

variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication (account level)."
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
# TLS
############################################

variable "tls_required" {
  type        = bool
  description = "Whether TLS is required."
  default     = true
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

variable "gateway_public_name" {
  type        = string
  description = "Name of the public Gateway resource created by the chart. Must match the gateway name the nullplatform agent resolves from container-orchestration.gateway.public_name (e.g. 'internet-facing' on AKS), otherwise HTTPRoutes are created with an unresolvable parentRef. Defaults to 'gateway-public' for backward compatibility: changing it on an existing install recreates the Gateway and orphans every HTTPRoute referencing the old name, causing a traffic outage until routes are regenerated."
  default     = "gateway-public"
}

variable "internal_azure_load_balancer_subnet" {
  description = "The name of the subnet to use in azure private load balancer"
  type        = string
  default     = "load_balancer"
}

variable "gateway_public_load_balancer_type" {
  type        = string
  description = "Load balancer type for the public gateway. Use 'internal' for Cloudflare Tunnel / VPN setups where public access is proxied through the private network. Use 'external' for direct internet exposure."
  default     = "external"
  validation {
    condition     = contains(["internal", "external"], var.gateway_public_load_balancer_type)
    error_message = "Must be 'internal' or 'external'."
  }
}

variable "gateway_public_azure_load_balancer_subnet" {
  type        = string
  description = "Name of the subnet for the public gateway's internal Azure load balancer. Only applied when gateway_public_load_balancer_type is 'internal'; empty by default, in which case Azure picks the subnet automatically."
  default     = ""
}

variable "gateway_use_cluster_ip" {
  description = ""
  type        = bool
  default     = false
}


variable "gateway_public_aws_dns_name" {
  description = ""
  type        = string
  default     = ""
}
variable "gateway_private_aws_dns_name" {
  description = ""
  type        = string
  default     = ""
}
############################################
# Control Plane
############################################

variable "control_plane_enabled" {
  type        = bool
  description = "Enable the control plane."
  default     = false
}

############################################
# Logging (global flag)
############################################

variable "logging_enabled" {
  type        = bool
  description = "Enable the logging layer."
  default     = true
}

variable "logging_application_logs_enabled" {
  type        = bool
  description = "Enable application log forwarding. Set to false to keep only http/sys metrics pipelines active across all providers."
  default     = true
}

variable "logging_mount_docker_containers" {
  type        = bool
  description = "Mount Docker container log paths. Enable when using Docker container runtime (e.g. Minikube)."
  default     = false
}

############################################
# Prometheus Exporter
############################################

variable "prometheus_enabled" {
  type        = bool
  description = "Enable the Prometheus exporter."
  default     = true
}

variable "exporter_prometheus_port" {
  type        = string
  description = "Port Number to Prometheus exporter."
  default     = "2021"
}

############################################
# GELF
############################################

variable "gelf_enabled" {
  type        = bool
  description = "Enable GELF output."
  default     = false
}

variable "gelf_host" {
  type        = string
  description = "GELF host."
  default     = ""
}

variable "gelf_port" {
  type        = number
  description = "GELF port."
  default     = 12201
}

############################################
# Loki
############################################

variable "loki_enabled" {
  type        = bool
  description = "Enable Loki output."
  default     = false
}

variable "loki_host" {
  type        = string
  description = "Loki host."
  default     = ""
}

variable "loki_port" {
  type        = number
  description = "Loki port."
  default     = 3100
}

variable "loki_user" {
  type        = string
  description = "Loki username (if applicable)."
  default     = ""
}

variable "loki_password" {
  type        = string
  description = "Loki password (if applicable)."
  sensitive   = true
  default     = ""
}

variable "loki_bearer_token" {
  type        = string
  description = "Loki bearer token (if applicable)."
  sensitive   = true
  default     = ""
}

############################################
# Dynatrace
############################################

variable "dynatrace_enabled" {
  type        = bool
  description = "Enable Dynatrace integration."
  default     = false
}

variable "dynatrace_logs_enabled" {
  type        = bool
  description = "Enable log forwarding to Dynatrace. Set to false to send only metrics."
  default     = true
}

variable "dynatrace_metrics_enabled" {
  type        = bool
  description = "Enable metrics forwarding to Dynatrace. Set to false to send only logs."
  default     = true
}

variable "dynatrace_api_key" {
  type        = string
  description = "Dynatrace API key."
  sensitive   = true
  default     = ""
}

variable "dynatrace_environment_id" {
  type        = string
  description = "Dynatrace environment ID."
  default     = ""
}

############################################
# Datadog
############################################

variable "datadog_enabled" {
  type        = bool
  description = "Enable Datadog integration."
  default     = false
}

variable "datadog_logs_enabled" {
  type        = bool
  description = "Enable log forwarding to Datadog. Set to false to send only metrics."
  default     = true
}

variable "datadog_metrics_enabled" {
  type        = bool
  description = "Enable metrics forwarding to Datadog. Set to false to send only logs."
  default     = true
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key."
  sensitive   = true
  default     = ""
}

variable "datadog_region" {
  type        = string
  description = "Datadog region (e.g., us, eu)."
  default     = ""
}

############################################
# New Relic
############################################

variable "newrelic_enabled" {
  type        = bool
  description = "Enable New Relic integration."
  default     = false
}

variable "newrelic_logs_enabled" {
  type        = bool
  description = "Enable log forwarding to New Relic. Set to false to send only metrics."
  default     = true
}

variable "newrelic_metrics_enabled" {
  type        = bool
  description = "Enable metrics forwarding to New Relic. Set to false to send only logs."
  default     = true
}

variable "newrelic_license_key" {
  type        = string
  description = "New Relic license key."
  sensitive   = true
  default     = ""
}

variable "newrelic_region" {
  type        = string
  description = "New Relic region (e.g., US, EU)."
  default     = ""
}

############################################
# CloudWatch
############################################

variable "cloudwatch_enabled" {
  type        = bool
  description = "Enable CloudWatch (global switch)."
  default     = false
}

variable "cloudwatch_logs_enabled" {
  type        = bool
  description = "Enable log forwarding to CloudWatch."
  default     = false
}

variable "cloudwatch_performance_metrics_enabled" {
  type        = bool
  description = "Enable performance metrics in CloudWatch."
  default     = false
}

variable "cloudwatch_custom_metrics_enabled" {
  type        = bool
  description = "Enable custom metrics in CloudWatch."
  default     = false
}

variable "cloudwatch_access_logs_enabled" {
  type        = bool
  description = "Enable access logs in CloudWatch."
  default     = false
}

variable "cloudwatch_service_account_annotations" {
  type        = map(string)
  description = "Annotations for the logs controller ServiceAccount (nullplatform-pod-metadata-reader-sa). Rendered only when cloudwatch_enabled is true. Set eks.amazonaws.com/role-arn here to use IRSA instead of the node instance role."
  default     = {}
}

############################################
# Metrics Server
############################################

variable "metrics_server_enabled" {
  type        = bool
  description = "Enable the metrics server."
  default     = false
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
# These are outputs from the security submodules:
#   infrastructure/aws/security
#   infrastructure/azure/security
#   infrastructure/gcp/security
############################################

variable "gateway_public_aws_security_group_id" {
  type        = string
  description = "The ID of the AWS security group for the public gateway. Output from infrastructure/aws/security module."
  default     = ""
}

variable "gateway_private_aws_security_group_id" {
  type        = string
  description = "The ID of the AWS security group for the private gateway. Output from infrastructure/aws/security module."
  default     = ""
}

variable "gateway_public_azure_nsg_id" {
  type        = string
  description = "The ID of the Azure NSG for the public gateway. Output from infrastructure/azure/security module."
  default     = ""
}

variable "gateway_private_azure_nsg_id" {
  type        = string
  description = "The ID of the Azure NSG for the private gateway. Output from infrastructure/azure/security module."
  default     = ""
}

variable "gateway_public_gcp_firewall_name" {
  type        = string
  description = "The name of the GCP firewall rule for the public gateway. Output from infrastructure/gcp/security module."
  default     = ""
}

variable "gateway_private_gcp_firewall_name" {
  type        = string
  description = "The name of the GCP firewall rule for the private gateway. Output from infrastructure/gcp/security module."
  default     = ""
}

# OCI Gateway Security
variable "gateway_public_oci_security_list_management_mode" {
  type        = string
  description = "OCI Load Balancer security list management mode for the public gateway. Options: 'All' (recommended - auto-manages security lists), 'Frontend' (only frontend rules), 'None' (manual management)."
  default     = "All"
}

variable "gateway_private_oci_security_list_management_mode" {
  type        = string
  description = "OCI Load Balancer security list management mode for the private gateway. Options: 'All' (recommended - auto-manages security lists), 'Frontend' (only frontend rules), 'None' (manual management)."
  default     = "All"
}

variable "gateway_public_oci_subnet" {
  type        = string
  description = "OCI subnet OCID for the public gateway load balancer (sets service.beta.kubernetes.io/oci-load-balancer-subnet1)."
  default     = ""
}

variable "gateway_private_oci_subnet" {
  type        = string
  description = "OCI subnet OCID for the private gateway load balancer (sets service.beta.kubernetes.io/oci-load-balancer-subnet1)."
  default     = ""
}

############################################
# Image Pull Secrets
############################################

variable "image_pull_secrets_enabled" {
  type        = bool
  description = "Create and use an image pull secret."
  default     = false
}

variable "image_pull_secrets_registry" {
  type        = string
  description = "Registry URL for the image pull secret."
  default     = ""
}

variable "image_pull_secrets_username" {
  type        = string
  description = "Registry username."
  default     = ""
}

variable "image_pull_secrets_password" {
  type        = string
  description = "Registry password or token."
  sensitive   = true
  default     = ""
}

############################################
# Ingress Controller
############################################
# ============================================================
# IngressControllers configuration
# ============================================================

variable "ingressControllers" {
  description = "Configuración de los IngressControllers públicos y privados"
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
