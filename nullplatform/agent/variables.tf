################################################################################
# Required Variables
################################################################################

variable "api_key" {
  description = "API key for authenticating with the nullplatform API"
  type        = string
  sensitive   = true
}

variable "image_tag" {
  # example: aws-0.10.0-nonroot
  description = "Image tag for the agent container image"
  type        = string
}

variable "cloud_provider" {
  description = "Cloud provider to use ('aws', 'gcp', 'azure', 'oci', or 'onprem' for self-managed/on-premise clusters)"
  type        = string
  validation {
    condition     = contains(["aws", "gcp", "azure", "oci", "onprem"], var.cloud_provider)
    error_message = "cloud_provider must be one of: 'aws', 'gcp', 'oci', 'azure' or 'onprem'."
  }
}

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

variable "release_name" {
  description = "Override for the Helm release name. Defaults to nullplatform-agent"
  type        = string
  default     = "nullplatform-agent"
}

variable "service_account_name" {
  description = "Override for the Kubernetes ServiceAccount name created by the Helm chart"
  type        = string
  default     = "nullplatform-agent"
}

variable "worker_orchestrator" {
  description = <<-EOT
    Configure worker orchestration: emit the chart's top-level "worker" block
    (backend, allowedRegistries, idleTTL and the per-package patches built from
    worker_orchestrated_packages and worker_k8s_packages) plus anything set in
    var.worker.

    Off by default: the module writes no "worker" key and builds no patches, so
    the chart's own defaults apply and scopes keep running inside the agent
    container (the legacy exec flow, see var.agent_repo). Turn it on to run
    packages in their own worker pods; var.worker, the package lists and
    worker_memory_limit are ignored while it is off.

    The agent's own env is the same either way: DOMAIN, DNS_TYPE, K8S_NAMESPACE
    and the rest are always published to the agent container.
  EOT
  type        = bool
  default     = false
}

variable "worker_orchestrated_packages" {
  description = <<-EOT
    Package slugs whose worker-orchestrator (package-exec) pods should run
    under var.service_account_name (the same IRSA identity as the agent
    itself), via a per-package worker patch. Add a package's slug here
    whenever its worker needs to assume an AWS role or needs Azure workload
    identity (the azure.workload.identity/use label is added through the same
    per-package patch); a worker for a package not listed here falls back to
    the namespace's default ServiceAccount. Resources are the same for every
    worker either way (var.worker_resources).

    This is separate from the "containers" scope's own k8s-deployment env
    vars (DNS_TYPE, DOMAIN, etc.), which remain specific to that package
    regardless of what's listed here.
  EOT
  type        = list(string)
  default     = ["containers"]
}

# Packages whose worker runs the k8s scope.
#
# The k8s scope is configured through env vars (DNS_TYPE, K8S_NAMESPACE, the
# template paths, CLUSTER_NAME, ...). The module injects those vars into the
# worker pod of every package listed here. "containers" is the k8s scope
# itself. Other packages run the same k8s code from their own image with a
# few steps replaced (scheduled-task, containers-datadog); they read the same
# vars, so they belong in this list too.
#
#   worker_k8s_packages = ["containers", "scheduled-task"]
#
# Packages not listed here (s3, rds, lambda, ...) do not get these vars.
variable "worker_k8s_packages" {
  description = "Package slugs whose worker runs the k8s scope and must receive its env vars (DNS_TYPE, K8S_NAMESPACE, template paths, CLUSTER_NAME, extra_envs). Add every package that runs the k8s scope code, e.g. [\"containers\", \"scheduled-task\"]."
  type        = list(string)
  default     = ["containers"]
}

# Name of the Kubernetes cluster the scopes are deployed to.
#
# The k8s scope uses it to find the cluster's OIDC provider when it creates
# the IAM role for a scope. It reaches the workers as the CLUSTER_NAME env var.
# Required when cloud_provider is "aws" (enforced by a precondition in main.tf,
# so a missing value fails at plan time instead of inside create-scope).
#
#   cluster_name = module.eks.eks_cluster_name
variable "cluster_name" {
  description = "Name of the Kubernetes cluster the scopes run in. Sent to the k8s workers as CLUSTER_NAME; the k8s scope uses it to find the EKS OIDC provider when creating IAM roles. Required when cloud_provider is 'aws'."
  type        = string
  default     = ""
}

variable "worker_memory_limit" {
  description = "Deprecated: use worker_resources.limits.memory; the chart now sets the workers' memory limit (2Gi from chart 3.4.0). When set, overrides the memory limit of every worker (it used to apply only to packages in worker_orchestrated_packages). Null (the default) renders nothing."
  type        = string
  default     = null
}

# example: 2.37.0 — 2.37.0+ ships the worker orchestrator (patches, per-install
# isolation, idle reaping)
variable "nullplatform_agent_helm_version" {
  description = "No default: every install pins this deliberately — see VERSIONS.md. Version of the nullplatform agent Helm chart to deploy"
  type        = string

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
    images keep working), idleTTL ("30m" by default, so worker Deployments
    left behind by an old/removed package revision get reaped instead of
    accumulating forever), and patches for the worker container
    (worker_resources for every worker, the deploy/DNS env vars below, and a
    serviceAccountName that always mirrors service_account_name). allowedRegistries and patches set here are
    concatenated with (not replacing) the module defaults — add your own
    registries or an extra patch rather than having to repeat the defaults;
    set backend or idleTTL here to override them outright (e.g. idleTTL = ""
    to disable the reaper, matching this module's pre-idleTTL-default
    behavior). Anything else — security, the legacy defaults/rules/pins —
    passes through as-is. See the nullplatform-agent chart values (>= 2.37.0)
    for the full shape. null = nothing extra beyond the defaults above.

    Example:
      worker = {
        allowedRegistries = ["123456789012.dkr.ecr.us-east-1.amazonaws.com/your-org/*"]
        patches           = [{ target = { package = "my-pkg" }, merge = { spec = { serviceAccountName = "np-agent-sa" } } }]
        idleTTL           = "1h"
      }
  EOT
  type        = any
  default     = null
}

variable "namespace" {
  description = "Kubernetes namespace where the nullplatform agent itself runs. This is NOT where scopes deploy their workloads — see var.workload_namespace."
  type        = string
  default     = "nullplatform-tools"
}

variable "workload_namespace" {
  description = "Kubernetes namespace scopes deploy their application pods into, handed to the k8s-scope workers as K8S_NAMESPACE. Defaults to the k8s scope's own default, which is what every pre-worker agent used."
  type        = string
  default     = "nullplatform"
}

variable "create_namespace" {
  description = "Create the namespace if it does not exist. Leave true unless another module already owns it: nullplatform/base declares the same namespace with Helm ownership metadata, so with no ordering edge between the two whichever applies second fails."
  type        = bool
  default     = true
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

variable "init_scripts" {
  description = "List of initialization scripts to execute during agent startup"
  type        = list(string)
  default     = []
}

# The agent answers /health only after it has cloned every var.agent_repo, which
# it does once at startup. Where that clone is slow (an emulated cluster, a thin
# or proxied uplink) the chart's default probes kill the container mid-clone and
# the pod crash-loops, re-cloning from scratch each time.
#
#   liveness_probe  = { initialDelaySeconds = 120, failureThreshold = 6 }
#   readiness_probe = { initialDelaySeconds = 60 }
variable "liveness_probe" {
  description = "Fields merged over the chart's livenessProbe (httpGet /health on 8080), e.g. { initialDelaySeconds = 120 }. Null (the default) renders nothing and leaves the chart's probe untouched."
  type        = any
  default     = null
}

variable "readiness_probe" {
  description = "Fields merged over the chart's readinessProbe (httpGet /health on 8080), e.g. { initialDelaySeconds = 60 }. Null (the default) renders nothing and leaves the chart's probe untouched."
  type        = any
  default     = null
}

# An evicted agent takes every action it is running down with it: a node
# autoscaler consolidating the agent's node fails the deploy in flight even
# though its pods come up fine, and leaves its resources behind. From chart
# 3.2.0 the chart itself protects the agent by default (do-not-disrupt /
# safe-to-evict annotations, startupProbe, terminationGracePeriodSeconds), so
# these variables only add to or override the chart: null/empty renders
# nothing and an existing install sees no diff.
variable "startup_probe" {
  description = "Fields merged over the chart's startupProbe (chart >= 3.2.0: httpGet /health on 8080, every 10s, up to 30 failures), e.g. { failureThreshold = 60 } for a slow repo clone. Null (the default) renders nothing and leaves the chart's probe untouched."
  type        = any
  default     = null
}

variable "pod_annotations" {
  description = "Annotations merged over the chart's podAnnotations. From chart 3.2.0 the chart sets karpenter.sh/do-not-disrupt = \"true\" and cluster-autoscaler.kubernetes.io/safe-to-evict = \"false\" so node autoscalers don't evict the agent mid-action; set a key to null to drop one of them (e.g. an admission policy that rejects it). Empty (the default) renders nothing."
  type        = map(string)
  default     = {}
}

variable "termination_grace_period_seconds" {
  description = "Seconds the agent gets to stop after SIGTERM (chart >= 3.2.0, which defaults to 60, and 120 from 3.3.0). It has to fit shutdown_drain_timeout_seconds plus 10s for the disconnect. Null (the default) renders nothing."
  type        = number
  default     = null

  validation {
    condition     = var.termination_grace_period_seconds == null || try(var.termination_grace_period_seconds > 30, false)
    error_message = "termination_grace_period_seconds must be above 30: the chart's preStop hook sleeps 30s, and the agent is killed when the grace period runs out."
  }
}

variable "shutdown_drain_timeout_seconds" {
  description = "Seconds the agent waits on SIGTERM for running commands to finish before it disconnects (chart >= 3.3.0, which defaults to 90, rendered as NP_SHUTDOWN_DRAIN_TIMEOUT). Commands still running after that are re-delivered to the next agent, so size it to the longest action (a start-blue-green takes ~70s). 0 disables the wait. Must stay at least 10s below termination_grace_period_seconds. Null (the default) renders nothing; extra_envs.NP_SHUTDOWN_DRAIN_TIMEOUT still takes precedence."
  type        = number
  default     = null

  validation {
    condition     = var.shutdown_drain_timeout_seconds == null || try(var.shutdown_drain_timeout_seconds >= 0 && floor(var.shutdown_drain_timeout_seconds) == var.shutdown_drain_timeout_seconds, false)
    error_message = "shutdown_drain_timeout_seconds must be a whole number of seconds, 0 or above."
  }
}

variable "pod_disruption_budget" {
  description = <<-EOT
    PodDisruptionBudget for the agent (chart >= 3.2.0), rendered as the chart's
    podDisruptionBudget values. Null (the default) renders nothing and the chart
    keeps it disabled. With a single replica only a budget that still allows an
    eviction is accepted: the chart refuses maxUnavailable = 0 and a minAvailable
    that is not below the replica count, since they would hang node drains and
    cluster upgrades.

    Example:
      pod_disruption_budget = { enabled = true, maxUnavailable = 1 }
  EOT
  type        = any
  default     = null
}

# Worker pods run the actions themselves (a deploy runs in its package's
# worker), so evicting a worker mid-action fails it just like evicting the
# agent does. The agent spawns them, so the chart's podAnnotations don't reach
# them: the module adds these through a worker patch with an empty target,
# which the chart applies to every worker.
variable "worker_pod_annotations" {
  description = "Annotations added to every worker pod (worker_orchestrator only) through a patch with an empty target. The defaults keep node autoscalers from evicting a worker mid-action: karpenter.sh/do-not-disrupt for Karpenter (EKS Auto Mode, AKS node auto-provisioning) and cluster-autoscaler.kubernetes.io/safe-to-evict for Cluster Autoscaler; a cluster without them ignores both. An idle worker then holds its node until the idle reaper (idleTTL, 30m by default) removes it. Empty renders no patch."
  type        = map(string)
  default = {
    "karpenter.sh/do-not-disrupt"                    = "true"
    "cluster-autoscaler.kubernetes.io/safe-to-evict" = "false"
  }
}

# The chart owns the agent's and the workers' resources (chart >= 3.4.0: agent
# requests 100m/256Mi with a 1Gi memory limit; every worker requests 100m/256Mi
# with limits 500m/2Gi). These variables are only for the cases that need
# something else: null (the default) renders nothing and the chart decides.
#
#   resources        = { requests = { cpu = "500m" } }
#   worker_resources = { limits = { memory = "4Gi" } }
variable "resources" {
  description = "Fields merged over the chart's resources for the agent container, e.g. { requests = { cpu = \"500m\" } }; Helm merges them key by key, so unset fields keep the chart's values. Null (the default), or empty requests and limits, renders nothing and leaves the chart's resources untouched."
  type = object({
    requests = optional(map(string), {})
    limits   = optional(map(string), {})
  })
  default = null
}

# Worker pods are spawned by the agent, so the agent's resources don't reach
# them: the module sets these through a worker patch with an empty target,
# which the chart applies to every worker, whatever its package, on top of the
# chart's worker.defaults.resources.
variable "worker_resources" {
  description = "Fields merged over the chart's worker resources (worker.defaults.resources) for every worker pod, whatever its package (worker_orchestrator only), rendered as a patch with an empty target, e.g. { limits = { memory = \"4Gi\" } }; unset fields keep the chart's values. To resize a single package, add a patch with target = { package = \"<slug>\" } in var.worker.patches instead. Null (the default), or empty requests and limits, renders no patch."
  type = object({
    requests = optional(map(string), {})
    limits   = optional(map(string), {})
  })
  default = null
}

variable "node_selector" {
  description = "nodeSelector for the agent pod, e.g. to pin it to a node pool that is not consolidated. Empty (the default) renders nothing."
  type        = map(string)
  default     = {}
}

variable "tolerations" {
  description = "Tolerations for the agent pod. Helm replaces lists instead of merging them, so this replaces the chart's defaults (node.kubernetes.io/not-ready and node.kubernetes.io/unreachable, NoExecute for 300s): include them if you still want them. Null (the default) renders nothing and keeps the chart's tolerations."
  # any, not list(any): tolerations with different keys (one with
  # tolerationSeconds, one without) don't unify into a single element type.
  type    = any
  default = null

  validation {
    condition     = var.tolerations == null || (!can(keys(var.tolerations)) && can([for t in var.tolerations : keys(t)]))
    error_message = "tolerations must be a list of toleration objects (key, operator, value, effect, tolerationSeconds)."
  }
}

variable "image_repository" {
  description = "Container image repository for the agent. Defaults to the official nullplatform image."
  type        = string
  default     = ""
}

variable "use_account_slug" {
  description = "Flag to determine whether to use the account slug in resource naming"
  type        = string
  default     = ""
}

################################################################################
# AWS Configuration
################################################################################

variable "aws_iam_role_arn" {
  description = "ARN of the AWS IAM role assigned to the agent. Required when cloud_provider is 'aws'."
  type        = string
  default     = ""
}

################################################################################
# Azure Configuration
################################################################################

variable "azure_client_id" {
  description = "Azure client ID of the Service Principal the agent authenticates with. Required when cloud_provider is 'azure', unless azure_workload_identity is true. With azure_workload_identity it can be set without a secret: it then annotates the ServiceAccount (the agent-wide default identity for SDK tools)."
  type        = string
  default     = null
}

variable "azure_client_secret" {
  description = "Azure client secret of the Service Principal the agent authenticates with. Required when cloud_provider is 'azure', unless azure_workload_identity is true."
  type        = string
  default     = null
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "Azure subscription ID. Required when cloud_provider is 'azure'."
  type        = string
  default     = null
}

variable "azure_resource_group" {
  description = "Azure resource group name. Required when cloud_provider is 'azure'."
  type        = string
  default     = null
}

variable "private_hosted_zone_rg" {
  description = "Resource group for private hosted zone. Required when cloud_provider is 'azure'."
  type        = string
  default     = null
}

variable "azure_workload_identity" {
  description = <<-EOT
    Run the agent and its worker-orchestrated pods with AKS Workload Identity:
    they get the label azure.workload.identity/use = "true", so the workload
    identity webhook projects the ServiceAccount token (AZURE_FEDERATED_TOKEN_FILE).
    The k8s scope then authenticates to Azure as the managed identity it resolves
    per scope dimension from the Identity & Access provider, and
    azure_client_id / azure_client_secret become optional. Only applies when
    cloud_provider is 'azure'.

    The managed identities the scope uses need a federated credential for
    subject system:serviceaccount:<namespace>:<service_account_name> (defaults:
    nullplatform-tools:nullplatform-agent) against the cluster's OIDC issuer.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "azure_tenant_id" {
  description = "Azure tenant ID. Required when cloud_provider is 'azure'."
  type        = string
  default     = null
}

################################################################################
# Gateway Configuration
################################################################################

variable "private_gateway_name" {
  description = "Name of the private/internal gateway used for routing"
  type        = string
  default     = "gateway-private"
}

variable "public_gateway_name" {
  description = "Name of the public gateway used for routing"
  type        = string
  default     = "gateway-public"
}

################################################################################
# DNS and Domain Configuration
################################################################################

variable "dns_type" {
  description = "Type of DNS Provider, e.g. azure, route53, or external_dns"
  type        = string
  default     = ""
}

variable "domain" {
  description = "Base domain name used across resources"
  type        = string
  default     = ""
}

################################################################################
# Image Configuration
################################################################################

variable "image_pull_secrets" {
  description = <<-EOT
    Pull secrets for the application pods the scopes deploy, published to the
    workers as IMAGE_PULL_SECRETS. Not the agent's own image — that one is
    image_pull_secret_name.

    A JSON document, not a secret name: {"ENABLED": bool, "SECRETS": [names]}.
    The workers hand the value straight to jq, and a bare name is not valid
    JSON, so it leaves them with no pull secrets at all instead of an error.

    Left empty, the workers derive it from the scope-configurations provider
    rather than from here.
  EOT
  type        = string
  default     = ""
}

variable "image_pull_secret_name" {
  description = <<-EOT
    Name of an existing pull secret, in the agent's own namespace, for pulling
    the agent image itself.

    Needed when that image comes from a private registry, which is the case for
    an install that mirrors it instead of pulling from the public repository.
    Empty leaves the chart's default and the pull stays anonymous, which is all
    a public image needs.

    The secret is not created here: it belongs to whoever owns the registry
    credentials. Its name is what the agent's namespace must already hold.

    Not the pull secrets the scopes attach to the application pods they deploy
    — those are image_pull_secrets, and they take a JSON document, not a name.
  EOT
  type        = string
  default     = ""
}

################################################################################
# Ingress / Networking Configuration
################################################################################

# Which ingress stack scopes deploy with — inside the worker pod
# (worker_orchestrator on) or inside the agent container itself (the legacy
# exec flow). The k8s scope ships two template sets under
# /home/agent/.np/nullplatform/scopes/k8s/deployment/templates: its default
# (AWS Load Balancer Controller Ingress) and istio/ (Gateway API HTTPRoutes).
# Nothing else selects between them: the scope does not read INGRESS_TYPE, it
# just renders whatever SERVICE_TEMPLATE / INITIAL_INGRESS_PATH /
# BLUE_GREEN_INGRESS_PATH point at. This input derives the three paths so a
# root module states the decision instead of copying image paths around.
variable "ingress_stack" {
  description = "Ingress stack scopes deploy with, in the worker pod or the agent container: \"alb\" keeps the k8s scope's own templates (AWS Load Balancer Controller Ingress), \"istio\" points it at the Gateway API templates baked in the scopes/containers image. service_template, initial_ingress_path and blue_green_ingress_path override the derived paths when set."
  type        = string
  default     = "istio"

  validation {
    condition     = contains(["alb", "istio"], var.ingress_stack)
    error_message = "ingress_stack must be \"alb\" or \"istio\"."
  }
}

variable "service_template" {
  description = "Path, inside the worker image, of the Service template the k8s scope renders. Empty (default) uses the template ingress_stack selects; set it only to point at a custom template."
  type        = string
  default     = ""
}

variable "initial_ingress_path" {
  description = "Path, inside the worker image, of the ingress/route template used on a scope's first deployment. Empty (default) uses the template ingress_stack selects; set it only to point at a custom template."
  type        = string
  default     = ""
}

variable "blue_green_ingress_path" {
  description = "Path, inside the worker image, of the ingress/route template used to shift traffic during a blue-green deployment. Empty (default) uses the template ingress_stack selects; set it only to point at a custom template."
  type        = string
  default     = ""
}

variable "extra_envs" {
  description = "Additional environment variables to pass to the agent"
  type        = map(string)
  default     = {}
}
