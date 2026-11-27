variable "nullplatform_base_helm_version" {
  # example: 2.44.0
  description = "No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the nullplatform base."
  type        = string

  validation {
    condition     = var.nullplatform_base_helm_version != "" && !contains(["latest", "main", "master"], lower(var.nullplatform_base_helm_version))
    error_message = "nullplatform_base_helm_version must be a non-empty fixed version, not empty and not a moving reference."
  }
}

variable "namespace" {
  description = "Kubernetes namespace where the agent runs."
  type        = string
  default     = "nullplatform-tools"
}

# Deprecated, no-op. The base chart only used the API key to build the
# nullplatform-secret Secret for the control plane agent sidecar it no longer
# runs (helm-charts ddf5332); nothing in the chart mounts that Secret. Kept so
# existing callers keep planning; remove it from your configuration.
variable "np_api_key" {
  type        = string
  sensitive   = true
  default     = null
  description = "Deprecated, ignored: the base chart no longer needs an API key. The agent's key is api_key in nullplatform/agent."
}

variable "k8s_provider" {
  type        = string
  description = "Cloud provider (eks, gke, aks, oke, aro, or generic for non-managed/on-premise clusters)."
  validation {
    condition     = contains(["eks", "gke", "aks", "oke", "aro", "generic"], var.k8s_provider)
    error_message = "k8s_provider must be one of: eks, gke, aks, oke, aro and generic"
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region where resources will be deployed."
  default     = "us-east-1"
}

variable "install_gateway_v2_crd" {
  type        = bool
  description = "Install/reconcile the Gateway API CRDs (see gateway_api_crd_ref) via the base chart's pre-install/pre-upgrade Job. Defaults to true so CRDs actually track gateway_api_crd_ref instead of staying frozen at whatever was present on first install — matches the base chart's own default. Safe on chart versions before global.gatewayApiCrdRef too: those only install when the CRD is missing, so pre-existing CRDs from another source are left untouched."
  default     = true
}

variable "gateway_api_crd_ref" {
  type        = string
  description = "Git ref (tag or commit) of kubernetes-sigs/gateway-api to install when install_gateway_v2_crd is true. Ignored on chart versions older than the one that introduced global.gatewayApiCrdRef. Default (v1.5.1) matches what Istio 1.30 documents installing; re-check istio.io's version-pinned docs when bumping Istio. Istio 1.30's own release notes warn that upgrading without also upgrading these CRDs leaves TLSRoute/ReferenceGrant invisible to istiod."
  default     = "v1.5.1"
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
  description = "Name of the subnet for the internal gateway's Azure load balancer. Empty by default, in which case Azure picks the subnet automatically. Must be the subnet's resource name (e.g. \"subnet-4\"), not the key it has in a subnets_definition map."
  type        = string
  default     = ""
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

variable "gateway_in_cluster_enabled" {
  type        = bool
  description = "Add in-cluster HTTP listeners (in-cluster-<port>) for service-to-service traffic between k8s scopes. Requires a nullplatform-base chart with gateway.inCluster support."
  default     = false
}

variable "gateway_in_cluster_mode" {
  type        = string
  description = "'shared' adds the listeners to the private gateway; 'dedicated' creates a separate ClusterIP gateway (gateway-in-cluster)."
  default     = "shared"
  validation {
    condition     = contains(["shared", "dedicated"], var.gateway_in_cluster_mode)
    error_message = "Must be 'shared' or 'dedicated'."
  }
}

variable "gateway_in_cluster_ports" {
  type        = list(number)
  description = "Ports clients use to call scopes in-cluster; one HTTP listener per port. Must cover every HTTP port the apps expose."
  default     = [80]
  validation {
    condition     = length(var.gateway_in_cluster_ports) > 0 && length(distinct(var.gateway_in_cluster_ports)) == length(var.gateway_in_cluster_ports) && alltrue([for p in var.gateway_in_cluster_ports : p == floor(p) && p >= 1 && p <= 65535 && !contains([443, 15000, 15001, 15004, 15006, 15008, 15009, 15020, 15021, 15090], p)])
    error_message = "Ports must be a non-empty list of unique integers in 1-65535, excluding 443 and Istio's reserved 15000, 15001, 15004, 15006, 15008, 15009, 15020, 15021, 15090."
  }
}

variable "gateway_in_cluster_hostname" {
  type        = string
  description = "Hostname of the in-cluster listeners in shared mode. Mandatory there, so real domains are never served over plain HTTP on the private load balancer."
  default     = "*.svc.cluster.local"
  validation {
    condition     = var.gateway_in_cluster_mode != "shared" || var.gateway_in_cluster_hostname != ""
    error_message = "gateway_in_cluster_hostname must not be empty when gateway_in_cluster_mode is 'shared'."
  }
}

variable "gateway_in_cluster_dedicated_hostname" {
  type        = string
  description = "Hostname of the in-cluster listeners in dedicated mode. Empty matches any host, which short names (svc, svc.ns) need."
  default     = ""
}

variable "gateway_in_cluster_dedicated_resources" {
  type = object({
    requests = optional(object({ cpu = optional(string), memory = optional(string) }))
    limits   = optional(object({ cpu = optional(string), memory = optional(string) }))
  })
  description = "Requests/limits for the dedicated in-cluster gateway pods. Null leaves the chart default. Needs Istio >= 1.26 (applied through the Gateway's parametersRef)."
  default     = null
  validation {
    condition = var.gateway_in_cluster_dedicated_resources == null || alltrue([
      for q in flatten([for b in ["requests", "limits"] : try(values(var.gateway_in_cluster_dedicated_resources[b]), [])]) :
      q == null || can(regex("^[0-9]+(\\.[0-9]+)?(m|k|M|G|T|P|E|Ki|Mi|Gi|Ti|Pi|Ei)?$", q))
    ])
    error_message = "cpu and memory must be Kubernetes quantities, e.g. 100m, 1, 256Mi."
  }
}

variable "gateway_in_cluster_dedicated_min_replicas" {
  type        = number
  description = "Minimum replicas of the dedicated in-cluster gateway. Null leaves the chart default."
  default     = null
  validation {
    condition     = var.gateway_in_cluster_dedicated_min_replicas == null || try(var.gateway_in_cluster_dedicated_min_replicas >= 1 && var.gateway_in_cluster_dedicated_min_replicas == floor(var.gateway_in_cluster_dedicated_min_replicas), false)
    error_message = "gateway_in_cluster_dedicated_min_replicas must be a whole number >= 1."
  }
}

variable "gateway_in_cluster_dedicated_max_replicas" {
  type        = number
  description = "Maximum replicas of the dedicated in-cluster gateway. Null leaves the chart default."
  default     = null
  validation {
    condition     = var.gateway_in_cluster_dedicated_max_replicas == null || try(var.gateway_in_cluster_dedicated_max_replicas >= 1 && var.gateway_in_cluster_dedicated_max_replicas == floor(var.gateway_in_cluster_dedicated_max_replicas) && (var.gateway_in_cluster_dedicated_min_replicas == null || var.gateway_in_cluster_dedicated_max_replicas >= var.gateway_in_cluster_dedicated_min_replicas), false)
    error_message = "gateway_in_cluster_dedicated_max_replicas must be a whole number >= 1 and >= gateway_in_cluster_dedicated_min_replicas."
  }
}
############################################
# Control Plane
############################################

variable "control_plane_enabled" {
  type        = bool
  default     = null
  description = "Deprecated, ignored: the base chart no longer runs a control plane agent; the flag only created an unused Secret."
}

# Deprecated, no-op. The base chart stopped running a control plane agent
# sidecar (helm-charts ddf5332); the agent is installed by nullplatform/agent,
# whose image_tag is the one that matters. Kept, like control_plane_enabled and
# np_api_key, so existing callers keep planning; remove them from your
# configuration.
variable "control_plane_agent_image_repository" {
  type        = string
  description = "Deprecated, ignored: the base chart no longer runs a control plane agent. Configure the agent image in nullplatform/agent."
  default     = null
}

variable "control_plane_agent_image_tag" {
  type        = string
  description = "Deprecated, ignored: the base chart no longer runs a control plane agent. Configure the agent image in nullplatform/agent (image_tag)."
  default     = null
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

variable "logging_controller_image_repository" {
  type        = string
  description = "Container image repository for the logs controller DaemonSet."
  default     = "public.ecr.aws/nullplatform/k8s-logs-controller"
}

variable "logging_istio_access_logs_enabled" {
  type        = bool
  description = "Build HTTP logs and metrics from the Istio gateway access log for scopes without the nginx sidecar (TRAFFIC_PROXY=istio). Renders one Telemetry per gateway; istiod needs the np-gateway-access-log provider (infrastructure/commons/istio gateway_access_log_enabled)."
  default     = false
}

variable "logging_controller_image_tag" {
  # example: 1.6.0
  type        = string
  description = "No default: every install pins this deliberately — see VERSIONS.md. Container image tag for the logs controller DaemonSet."

  validation {
    condition     = var.logging_controller_image_tag != "" && !contains(["latest", "main", "master"], lower(var.logging_controller_image_tag))
    error_message = "logging_controller_image_tag must be a non-empty fixed version, not empty and not a moving reference."
  }
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

# Surfaces the deprecation at plan time (a check failure is a warning, never an
# error) instead of silently ignoring values callers still pass.
check "control_plane_agent_inputs_deprecated" {
  assert {
    condition     = var.control_plane_agent_image_tag == null && var.control_plane_agent_image_repository == null && var.control_plane_enabled == null && var.np_api_key == null
    error_message = "control_plane_enabled, control_plane_agent_image_tag, control_plane_agent_image_repository and np_api_key are deprecated and ignored: the base chart no longer runs a control plane agent nor needs an API key. Remove them; the agent image and key live in nullplatform/agent (image_tag, api_key)."
  }
}
