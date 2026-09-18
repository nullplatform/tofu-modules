################################################################################
# Agent repository configuration
################################################################################

locals {

  tags = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])

  api_key    = var.api_key
  agent_repo = join(",", var.agent_repo)

  default_args = [
    "--tags=$(TAGS)",
    "--apikey=$(NP_API_KEY)",
    "--runtime=host",
    "--command-executor-env=NP_API_KEY=$(NP_API_KEY)",
    "--command-executor-debug",
    "--webserver-enabled",
    "--command-executor-git-command-repos=$(AGENT_REPO)"
  ]

  cloud_args = {
    aws   = []
    gcp   = []
    azure = []
    oci   = []
  }

  all_args = concat(local.default_args, lookup(local.cloud_args, var.cloud_provider, []))

  default_config = {
    NP_API_KEY = local.api_key
    TAGS       = local.tags
    IMAGE_TAG  = var.image_tag
    AGENT_REPO = local.agent_repo
  }

  # Deploy/DNS settings shared by both the agent container (legacy
  # command-executor exec flow, var.agent_repo) and worker pods
  # (worker_orchestrator) — same values regardless of destination, sent to
  # both unconditionally. 34238fd2 (#554) sent them to only one side and
  # broke installs still relying on the other; a root module can also mix
  # both flows at once (some scopes legacy, some worker-orchestrated), so
  # neither side can be skipped based on var.worker_orchestrator.
  shared_deploy_config = {
    DOMAIN                  = var.domain
    DNS_TYPE                = var.dns_type
    USE_ACCOUNT_SLUG        = var.use_account_slug
    IMAGE_PULL_SECRETS      = var.image_pull_secrets
    CLUSTER_NAME            = var.cluster_name
    TRAFFIC_CONTAINER_IMAGE = "${var.agent_traffic_manager_repository}:${var.agent_traffic_manager_tag}"
    PRIVATE_GATEWAY_NAME    = var.private_gateway_name
    PUBLIC_GATEWAY_NAME     = var.public_gateway_name
    # Both the agent's own scope scripts and the worker read K8S_NAMESPACE
    # for the namespace workloads deploy into (verified against
    # helm-charts/charts/agent and the scopes repo: neither reads a bare
    # "NAMESPACE" key — the chart's only namespace-flavored hardcoded env var
    # is NP_WORKER_NAMESPACE, and the k8s scope's build_context resolves
    # NAMESPACE_OVERRIDE/K8S_NAMESPACE only). A plain "NAMESPACE" key used to
    # be sent too (removed here) — it had no consumer.
    K8S_NAMESPACE = var.workload_namespace
  }

  # Cloud-specific slice of shared_deploy_config. PRIVATE_DOMAIN is
  # deliberately absent: var.private_domain was dropped in 34238fd2 (#554)
  # and is not coming back — pass it through extra_envs if a scope still
  # reads it.
  shared_cloud_config = {
    azure = {
      PRIVATE_HOSTED_ZONE_RG = var.private_hosted_zone_rg
      RESOURCE_GROUP         = var.azure_resource_group
      AZURE_SUBSCRIPTION_ID  = var.azure_subscription_id
      AZURE_CLIENT_SECRET    = var.azure_client_secret
      AZURE_CLIENT_ID        = var.azure_client_id
      AZURE_TENANT_ID        = var.azure_tenant_id
    }
  }

  # Cloud-specific slice of the agent container's own env: shared_cloud_config
  # plus AWS_IAM_ROLE_ARN, which the agent assumes directly (the worker gets
  # its AWS identity via serviceAccountName in a patch instead, see
  # worker_common_patches).
  cloud_config = merge(local.shared_cloud_config, {
    aws = {
      AWS_IAM_ROLE_ARN = var.aws_iam_role_arn
    }
  })

  # Drop nulls: a null reaching templatefile fails with an error that names no
  # variable, before any precondition gets to report the actual missing input.
  all_config = {
    for k, v in merge(
      local.default_config,
      local.deploy_config,
      lookup(local.cloud_config, var.cloud_provider, {}),
      var.extra_envs,
    ) : k => v if v != null
  }

  # Template paths per ingress stack. "alb" sends empty values so the k8s scope
  # falls back to its own defaults (AWS Load Balancer Controller Ingress).
  # "istio" points at the Gateway API templates the scopes image bakes in —
  # the path differs by execution context: worker_orchestrator = true runs the
  # k8s scope inside its own worker pod, image rooted at /app/pkg; false runs
  # it via the legacy command-executor exec flow inside the agent container,
  # where the scopes repo lands under the agent user's home instead. An
  # explicit service_template / initial_ingress_path / blue_green_ingress_path
  # wins over either — that's the only override point; there's no separate
  # per-stack default variable, since a module call pins one ingress_stack for
  # the life of the install and the universal override already covers pointing
  # at a different image path if the scopes image ever moves these.
  ingress_stack_templates = {
    alb = {
      SERVICE_TEMPLATE        = ""
      INITIAL_INGRESS_PATH    = ""
      BLUE_GREEN_INGRESS_PATH = ""
    }
    istio = var.worker_orchestrator ? {
      SERVICE_TEMPLATE        = "/app/pkg/k8s/deployment/templates/istio/service.yaml.tpl"
      INITIAL_INGRESS_PATH    = "/app/pkg/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
      BLUE_GREEN_INGRESS_PATH = "/app/pkg/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
      } : {
      SERVICE_TEMPLATE        = "/home/agent/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
      INITIAL_INGRESS_PATH    = "/home/agent/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
      BLUE_GREEN_INGRESS_PATH = "/home/agent/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
    }
  }
  stack_templates = local.ingress_stack_templates[var.ingress_stack]

  # Resolved once and shared by the agent env and the worker patch: an
  # explicit path always wins over the one ingress_stack derives.
  ingress_paths = {
    SERVICE_TEMPLATE        = var.service_template != "" ? var.service_template : local.stack_templates.SERVICE_TEMPLATE
    INITIAL_INGRESS_PATH    = var.initial_ingress_path != "" ? var.initial_ingress_path : local.stack_templates.INITIAL_INGRESS_PATH
    BLUE_GREEN_INGRESS_PATH = var.blue_green_ingress_path != "" ? var.blue_green_ingress_path : local.stack_templates.BLUE_GREEN_INGRESS_PATH
  }

  # Deploy/DNS settings sent to both the agent container's own env
  # (all_config below) and worker pods (worker_all_config): shared_deploy_config
  # plus the ingress paths. The same three paths the worker gets, so both
  # execution paths render the same ingress stack. With ingress_stack =
  # "alb" these are exactly the raw var values, as they were before 34238fd2.
  deploy_config = merge(
    local.shared_deploy_config,
    local.ingress_paths,
  )

  worker_all_config = merge(
    local.deploy_config,
    lookup(local.shared_cloud_config, var.cloud_provider, {}),
    var.extra_envs,
  )

  # Generic identity + resources — one patch per package in
  # var.worker_orchestrated_packages, so any worker-orchestrated package's pod
  # (not just "containers") gets the agent's own ServiceAccount (to assume its
  # role's trusted AWS roles) and enough memory to run its own tooling (e.g.
  # tofu init/apply), instead of the chart's own thin defaults.
  #
  # Built only while var.worker_orchestrator is true; with the toggle off the
  # module writes no worker block at all, so there is nothing to patch.
  worker_common_patches = var.worker_orchestrator ? [
    for pkg in var.worker_orchestrated_packages : {
      target = { package = pkg }
      merge = {
        spec = merge(
          var.service_account_name != "" ? { serviceAccountName = var.service_account_name } : {},
          {
            containers = [
              { name = "worker", resources = { limits = { memory = var.worker_memory_limit } } }
            ]
          }
        )
      }
    }
  ] : []

  # Environment variables for the workers that run the k8s scope.
  #
  # The k8s scope reads its settings from env vars (DNS_TYPE, K8S_NAMESPACE,
  # the template paths, CLUSTER_NAME, ...). local.worker_all_config holds all
  # of them. This block turns that map into one pod patch per package listed
  # in var.worker_k8s_packages, so every one of those workers boots with the
  # same variables.
  #
  # With the default, var.worker_k8s_packages = ["containers"], the result is
  # a single patch:
  #
  #   - target: { package: containers }
  #     merge:
  #       spec:
  #         containers:
  #           - name: worker
  #             env:
  #               - { name: DNS_TYPE, value: external_dns }
  #               - { name: K8S_NAMESPACE, value: nullplatform }
  #               ...
  #
  # With ["containers", "scheduled-task"] you get two patches with the same
  # env, one per package. Packages not in the list get none of these vars.
  worker_k8s_env_patches = var.worker_orchestrator ? [
    for pkg in var.worker_k8s_packages : {
      target = { package = pkg }
      merge = {
        spec = {
          containers = [
            {
              name = "worker"
              env  = [for k, v in local.worker_all_config : { name = k, value = v }]
            }
          ]
        }
      }
    }
  ] : []

  worker_defaults = {
    backend           = "kubernetes"
    allowedRegistries = ["public.ecr.aws/nullplatform/*"]
    patches           = concat(local.worker_common_patches, local.worker_k8s_env_patches)
    # Reap worker-orchestrated pods (and their Deployments) after 30m with no
    # activity. Previously unset (NP_WORKER_IDLE_TTL empty), which disables
    # the reaper entirely — stale workers from old package revisions or
    # removed packages accumulate forever instead of being cleaned up.
    # Override per-install via var.worker.idleTTL (see its docs for the
    # shape) if a longer/shorter window is needed.
    idleTTL = "30m"
  }

  # Consumed by the template only while var.worker_orchestrator is true. With
  # the toggle off the template omits the top-level "worker" key entirely, so
  # the chart keeps its own worker defaults and nothing is patched — the two
  # patch lists above are empty in that mode as well.
  worker_final = merge(
    local.worker_defaults,
    try({ for k, v in var.worker : k => v if !contains(["patches", "allowedRegistries"], k) }, {}),
    {
      patches           = concat(local.worker_defaults.patches, try(var.worker.patches, []))
      allowedRegistries = distinct(concat(local.worker_defaults.allowedRegistries, try(var.worker.allowedRegistries, [])))
    }
  )

  # Single combined values document — worker is just another top-level key
  # of the same agent chart values, not a second Helm values layer.
  nullplatform_agent_values = templatefile("${path.module}/templates/nullplatform_agent_values.tmpl.yaml", {
    args                 = local.all_args
    config_values        = local.all_config
    image_tag            = var.image_tag
    image_repository     = var.image_repository
    aws_iam_role_arn     = var.cloud_provider == "aws" ? var.aws_iam_role_arn : ""
    init_scripts         = var.init_scripts
    service_account_name = var.service_account_name
    worker_orchestrator  = var.worker_orchestrator
    worker               = local.worker_final
  })
}
