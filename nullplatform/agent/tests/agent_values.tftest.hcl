mock_provider "helm" {}
mock_provider "nullplatform" {}

variables {
  api_key                         = "test-api-key"
  tags_selectors                  = { dimension = "prod" }
  cloud_provider                  = "aws"
  aws_iam_role_arn                = "arn:aws:iam::123456789012:role/agent"
  cluster_name                    = "test-cluster"
  image_tag                       = "0.9.2"
  nullplatform_agent_helm_version = "2.37.0"
  agent_traffic_manager_tag       = "1.8.0"

  # The module ships worker orchestration OFF. Most runs here assert the worker
  # block, so they opt in; the runs that assert the off path set it to false.
  worker_orchestrator = true
}

################################################################################
# Traffic manager image
################################################################################

# Pinning the traffic manager used to mean passing the whole image string through
# extra_envs. The registry now lives in the module and only the tag is exposed.
# TRAFFIC_CONTAINER_IMAGE is part of deploy_config, sent to both the agent's
# own configuration.values and the worker's env; this run only checks the
# worker's env-list rendering.
run "traffic_manager_image_is_assembled_from_the_tag" {
  command = plan

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"name\": \"TRAFFIC_CONTAINER_IMAGE\"") && strcontains(helm_release.agent.values[0], "\"value\": \"public.ecr.aws/nullplatform/k8s-traffic-manager:1.8.0\"")
    error_message = "TRAFFIC_CONTAINER_IMAGE should be built from the repository default and the pinned tag, and reach the worker's env"
  }
}

run "traffic_manager_repository_is_overridable" {
  command = plan

  variables {
    agent_traffic_manager_repository = "my-mirror.example.com/nullplatform/k8s-traffic-manager"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"name\": \"TRAFFIC_CONTAINER_IMAGE\"") && strcontains(helm_release.agent.values[0], "\"value\": \"my-mirror.example.com/nullplatform/k8s-traffic-manager:1.8.0\"")
    error_message = "the registry must be overridable for a mirrored path"
  }
}

run "extra_envs_still_overrides_the_traffic_manager_image" {
  command = plan

  variables {
    extra_envs = {
      TRAFFIC_CONTAINER_IMAGE = "public.ecr.aws/nullplatform/k8s-traffic-manager@sha256:abc123"
    }
  }

  # extra_envs is merged last, so the previous way of doing this keeps working. That is what
  # makes exposing the tag an addition rather than a breaking change.
  assert {
    condition     = strcontains(helm_release.agent.values[0], "TRAFFIC_CONTAINER_IMAGE: \"public.ecr.aws/nullplatform/k8s-traffic-manager@sha256:abc123\"")
    error_message = "extra_envs must keep precedence over the assembled image"
  }
}

# The worker has its own env map (worker_all_config), layered with extra_envs
# the same way all_config is for the agent, so an override reaches both.
run "extra_envs_also_reaches_the_worker" {
  command = plan

  variables {
    extra_envs = {
      TRAFFIC_CONTAINER_IMAGE = "public.ecr.aws/nullplatform/k8s-traffic-manager@sha256:abc123"
    }
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"name\": \"TRAFFIC_CONTAINER_IMAGE\"") && strcontains(helm_release.agent.values[0], "\"value\": \"public.ecr.aws/nullplatform/k8s-traffic-manager@sha256:abc123\"")
    error_message = "extra_envs overrides must also reach the worker's env"
  }
}

################################################################################
# Worker orchestration
################################################################################

run "worker_block_present_by_default_with_expected_env" {
  command = plan

  variables {
    domain    = "playground.nullapps.io"
    dns_type  = "external_dns"
    namespace = "nullplatform"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"backend\": \"kubernetes\"")
    error_message = "worker block must always be emitted, even without var.worker set"
  }

  assert {
    condition = (
      strcontains(helm_release.agent.values[0], "\"name\": \"DNS_TYPE\"") &&
      strcontains(helm_release.agent.values[0], "\"value\": \"external_dns\"") &&
      strcontains(helm_release.agent.values[0], "\"name\": \"DOMAIN\"") &&
      strcontains(helm_release.agent.values[0], "\"value\": \"playground.nullapps.io\"") &&
      strcontains(helm_release.agent.values[0], "\"name\": \"K8S_NAMESPACE\"") &&
      strcontains(helm_release.agent.values[0], "\"value\": \"nullplatform\"") &&
      strcontains(helm_release.agent.values[0], "\"name\": \"TRAFFIC_CONTAINER_IMAGE\"") &&
      strcontains(helm_release.agent.values[0], "\"value\": \"public.ecr.aws/nullplatform/k8s-traffic-manager:1.8.0\"")
    )
    error_message = "worker env must carry the deploy/DNS vars plus namespace and the traffic-manager image"
  }
}

# backend/allowedRegistries have no dedicated variables — they're just keys
# on var.worker, same as idleTTL or any other chart field.
# backend is a plain override (var.worker's value wins outright); allowedRegistries
# is additive like patches — var.worker's entries join the default rather than
# replacing it, so the platform's own scope images keep pulling.
run "worker_backend_overrides_allowed_registries_extends" {
  command = plan

  variables {
    worker = {
      backend           = "nomad"
      allowedRegistries = ["123456789012.dkr.ecr.us-east-1.amazonaws.com/my-org/*"]
    }
  }

  assert {
    condition = (
      strcontains(helm_release.agent.values[0], "\"backend\": \"nomad\"") &&
      !strcontains(helm_release.agent.values[0], "\"backend\": \"kubernetes\"")
    )
    error_message = "var.worker.backend must override the module default outright"
  }

  assert {
    condition = (
      strcontains(helm_release.agent.values[0], "public.ecr.aws/nullplatform/*") &&
      strcontains(helm_release.agent.values[0], "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-org/*")
    )
    error_message = "var.worker.allowedRegistries must extend the default registry list, not replace it"
  }
}

# The worker container has no service-account concept of its own — it always
# mirrors the agent's own service_account_name.
run "worker_service_account_mirrors_service_account_name" {
  command = plan

  variables {
    service_account_name = "my-sa"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"serviceAccountName\": \"my-sa\"")
    error_message = "worker's serviceAccountName should mirror service_account_name"
  }
}

run "worker_orchestrated_packages_gets_its_own_service_account_patch" {
  command = plan

  variables {
    worker_orchestrated_packages = ["containers", "aws-s3-bucket"]
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"package\": \"aws-s3-bucket\"")
    error_message = "a package listed in worker_orchestrated_packages must get its own patch target"
  }

  assert {
    condition     = length(regexall("\"serviceAccountName\": \"nullplatform-agent\"", helm_release.agent.values[0])) == 2
    error_message = "each package in worker_orchestrated_packages must get its own serviceAccountName patch (one per package, here 2)"
  }

  # Resources come from the base patch only, so every worker gets the same.
  assert {
    condition = length([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches : p
      if try(p.target.package, null) != null && try(p.merge.spec.containers[0].resources, null) != null
    ]) == 0
    error_message = "no per-package patch may set resources: every worker must get the same ones"
  }
}

# Deprecated, kept so existing callers still plan; it now sets the limit of
# every worker.
run "worker_memory_limit_still_overrides_the_limit_of_every_worker" {
  command = plan

  variables {
    worker_memory_limit = "4Gi"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).worker.patches[1].merge.spec.containers[0].resources == { limits = { memory = "4Gi" } }
    error_message = "a set worker_memory_limit must render the memory limit in the base patch"
  }
}

run "worker_defaults" {
  command = plan

  assert {
    condition     = strcontains(helm_release.agent.values[0], "public.ecr.aws/nullplatform/*")
    error_message = "allowedRegistries must default to public.ecr.aws/nullplatform/* so the platform's own scope images keep pulling"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"serviceAccountName\": \"nullplatform-agent\"")
    error_message = "the worker's serviceAccountName must default to service_account_name's default (nullplatform-agent)"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"idleTTL\": \"30m\"")
    error_message = "idleTTL must default to 30m so worker Deployments from an old/removed package revision get reaped instead of accumulating forever"
  }
}

# idleTTL is a plain override (like backend), not additive (like
# allowedRegistries/patches) — var.worker's value must win outright,
# including the empty string, which disables the reaper.
run "worker_idle_ttl_override_wins_outright" {
  command = plan

  variables {
    worker = {
      idleTTL = ""
    }
  }

  assert {
    condition = (
      strcontains(helm_release.agent.values[0], "\"idleTTL\": \"\"") &&
      !strcontains(helm_release.agent.values[0], "\"idleTTL\": \"30m\"")
    )
    error_message = "var.worker.idleTTL must override the module default outright, including disabling it with an empty string"
  }
}

# var.worker stays available as an extra/override layer on top of the computed
# defaults: its own patches are concatenated (not dropped, so a caller wanting
# a different memory limit adds their own patch rather than replacing ours),
# and its other top-level keys (e.g. idleTTL) pass through.
run "worker_extra_patches_and_overrides_are_merged_not_replaced" {
  command = plan

  variables {
    worker = {
      idleTTL = "30m"
      patches = [
        { target = { package = "my-pkg" }, merge = { spec = { serviceAccountName = "np-agent-sa" } } }
      ]
    }
  }

  assert {
    condition = (
      strcontains(helm_release.agent.values[0], "\"idleTTL\": \"30m\"") &&
      strcontains(helm_release.agent.values[0], "\"package\": \"my-pkg\"") &&
      strcontains(helm_release.agent.values[0], "\"name\": \"worker\"")
    )
    error_message = "var.worker's own patches/keys must be merged alongside the computed worker-container patch, not replace it"
  }
}

################################################################################
# Legacy exec repos
################################################################################

run "agent_repo_joins_multiple_repos_with_no_spaces" {
  command = plan

  variables {
    agent_repo = [
      "https://github.com/nullplatform/scopes.git#v1.15.1",
      "https://github.com/nullplatform/services-s-3.git#v0.3.0",
    ]
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "AGENT_REPO: \"https://github.com/nullplatform/scopes.git#v1.15.1,https://github.com/nullplatform/services-s-3.git#v0.3.0\"")
    error_message = "agent_repo entries must be joined with a comma and no spaces"
  }
}

run "agent_repo_defaults_to_empty" {
  command = plan

  assert {
    condition     = strcontains(helm_release.agent.values[0], "AGENT_REPO: \"\"")
    error_message = "agent_repo must default to an empty list, joining to an empty string"
  }
}

# atomic/cleanup_on_fail default to false in the provider — without them a
# failed upgrade sticks in "failed" with orphaned resources instead of rolling
# back (observed in production: an "Error upgrading chart" left the release
# stuck until a manual retry).
run "helm_release_rolls_back_failed_upgrades" {
  command = plan

  assert {
    condition     = helm_release.agent.atomic == true
    error_message = "atomic must be true so a failed upgrade rolls back instead of sticking in failed"
  }

  assert {
    condition     = helm_release.agent.cleanup_on_fail == true
    error_message = "cleanup_on_fail must be true so a failed upgrade cleans up orphaned resources"
  }

  assert {
    condition     = helm_release.agent.create_namespace == true
    error_message = "create_namespace must default to true (the pre-existing behavior) so a fresh install doesn't die on a missing namespace"
  }
}

run "create_namespace_is_overridable" {
  command = plan

  variables {
    create_namespace = false
  }

  assert {
    condition     = helm_release.agent.create_namespace == false
    error_message = "create_namespace must be overridable to false for stacks where another module already owns the namespace"
  }
}

# yamlencode folds strings longer than ~80 characters at a space, as YAML
# allows. The values template used to re-emit the encoded block line by line,
# leaving an empty line between every two lines; inside a folded string an
# empty line is a literal newline, so a long patch command reached the chart
# split in two. Decoding the rendered values must give the string back intact.
run "long_worker_patch_strings_survive_rendering" {
  command = plan

  variables {
    worker = {
      patches = [{
        target = { package = "scopes-lambda" }
        merge = {
          spec = {
            containers = [{
              name    = "worker"
              command = ["sh", "-c", "wget -qO- https://github.com/nullplatform/scopes-networking/archive/refs/tags/v0.1.0.tar.gz | tar -xz --strip-components=1 -C /overrides"]
            }]
          }
        }
      }]
    }
  }

  assert {
    condition = anytrue([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches :
      try(p.merge.spec.containers[0].command[2], "") == "wget -qO- https://github.com/nullplatform/scopes-networking/archive/refs/tags/v0.1.0.tar.gz | tar -xz --strip-components=1 -C /overrides"
    ])
    error_message = "a worker patch string longer than the yamlencode fold width must not pick up a newline when the values are rendered"
  }
}

################################################################################
# ingress_stack
################################################################################

# The k8s scope only knows which ingress stack to deploy through the three
# template paths; nothing reads an INGRESS_TYPE. ingress_stack defaults to
# "istio", so the module derives the Gateway API template paths without any
# variables set. The istio paths themselves differ by execution context: with
# worker_orchestrator on (this file's default) the k8s scope runs inside its
# own worker pod, image rooted at /app/pkg; off, it runs via the legacy
# command-executor exec flow inside the agent container, where the scopes
# repo lands under the agent user's home instead.
run "ingress_stack_defaults_to_istio_and_derives_the_worker_gateway_api_template_paths" {
  command = plan

  assert {
    condition = alltrue([
      for key, want in {
        SERVICE_TEMPLATE        = "/app/pkg/k8s/deployment/templates/istio/service.yaml.tpl"
        INITIAL_INGRESS_PATH    = "/app/pkg/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
        BLUE_GREEN_INGRESS_PATH = "/app/pkg/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
      } :
      anytrue([
        for p in yamldecode(helm_release.agent.values[0]).worker.patches :
        anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == key && e.value == want])
        if try(p.target.package, "") == "containers"
      ])
    ])
    error_message = "with worker_orchestrator on, the containers worker must default to the istio templates baked in the worker image"
  }
}

run "ingress_stack_defaults_to_istio_and_derives_the_legacy_gateway_api_template_paths" {
  command = plan

  variables {
    worker_orchestrator = false
  }

  assert {
    condition = alltrue([
      for key, want in {
        SERVICE_TEMPLATE        = "/home/agent/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
        INITIAL_INGRESS_PATH    = "/home/agent/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
        BLUE_GREEN_INGRESS_PATH = "/home/agent/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
      } :
      strcontains(helm_release.agent.values[0], "\n    ${key}: \"${want}\"")
    ])
    error_message = "with worker_orchestrator off, the agent's own env must default to the istio templates baked under the agent user's home"
  }
}

run "ingress_stack_alb_leaves_the_scope_templates" {
  command = plan

  variables {
    ingress_stack = "alb"
  }

  assert {
    condition = alltrue([
      for key in ["SERVICE_TEMPLATE", "INITIAL_INGRESS_PATH", "BLUE_GREEN_INGRESS_PATH"] :
      anytrue([
        for p in yamldecode(helm_release.agent.values[0]).worker.patches :
        anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == key && e.value == ""])
        if try(p.target.package, "") == "containers"
      ])
    ])
    error_message = "with ingress_stack = alb the three template paths must render empty so the k8s scope uses its own templates"
  }
}

run "explicit_template_paths_override_ingress_stack" {
  command = plan

  variables {
    ingress_stack    = "istio"
    service_template = "/custom/service.yaml.tpl"
  }

  assert {
    condition = anytrue([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches :
      anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == "SERVICE_TEMPLATE" && e.value == "/custom/service.yaml.tpl"])
      if try(p.target.package, "") == "containers"
    ])
    error_message = "an explicit service_template must win over the path ingress_stack derives"
  }
}

run "ingress_stack_rejects_unknown_stacks" {
  command = plan

  variables {
    ingress_stack = "nginx"
  }

  expect_failures = [var.ingress_stack]
}

################################################################################
# worker_k8s_packages / cluster_name
################################################################################

# Helper shape reused below: does the patch targeting `pkg` carry env `key`?
run "k8s_env_reaches_only_the_containers_worker_by_default" {
  command = plan

  variables {
    dns_type = "external_dns"
  }

  assert {
    condition = anytrue([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches :
      anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == "DNS_TYPE" && e.value == "external_dns"])
      if try(p.target.package, "") == "containers"
    ])
    error_message = "the containers worker must keep receiving the k8s scope env by default"
  }

  assert {
    condition = length([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches : p
      if try(p.target.package, "") != "containers" && length(try(p.merge.spec.containers[0].env, [])) > 0
    ]) == 0
    error_message = "no other package should receive the k8s scope env unless listed in worker_k8s_packages"
  }
}

run "k8s_env_reaches_every_listed_package" {
  command = plan

  variables {
    dns_type                     = "external_dns"
    worker_orchestrated_packages = ["containers", "scheduled-task"]
    worker_k8s_packages          = ["containers", "scheduled-task"]
  }

  assert {
    condition = alltrue([
      for pkg in ["containers", "scheduled-task"] :
      anytrue([
        for p in yamldecode(helm_release.agent.values[0]).worker.patches :
        anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == "DNS_TYPE" && e.value == "external_dns"])
        if try(p.target.package, "") == pkg
      ])
    ])
    error_message = "every package in worker_k8s_packages must get the k8s scope env, not just containers"
  }
}

run "cluster_name_is_published_to_the_k8s_workers_when_set" {
  command = plan

  variables {
    cluster_name = "my-eks"
  }

  assert {
    condition = anytrue([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches :
      anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == "CLUSTER_NAME" && e.value == "my-eks"])
      if try(p.target.package, "") == "containers"
    ])
    error_message = "cluster_name must reach the k8s worker as CLUSTER_NAME"
  }
}

run "cluster_name_is_required_on_aws" {
  command = plan

  variables {
    cluster_name = ""
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "cluster_name_can_still_arrive_through_extra_envs" {
  command = plan

  variables {
    cluster_name = ""
    extra_envs   = { CLUSTER_NAME = "legacy-eks" }
  }

  assert {
    condition = anytrue([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches :
      anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == "CLUSTER_NAME" && e.value == "legacy-eks"])
      if try(p.target.package, "") == "containers"
    ])
    error_message = "an existing installation passing CLUSTER_NAME through extra_envs must keep working"
  }
}

################################################################################
# Deploy/DNS variables on the agent container
################################################################################

# 34238fd2 (#554) moved DOMAIN/DNS_TYPE/USE_ACCOUNT_SLUG/IMAGE_PULL_SECRETS/
# SERVICE_TEMPLATE/INITIAL_INGRESS_PATH/BLUE_GREEN_INGRESS_PATH/K8S_NAMESPACE/
# CLUSTER_NAME out of the agent's own configuration.values and into the worker
# patch. Installs whose scopes still run inside the agent (the legacy
# command-executor exec flow) lost them. They must reach the agent again — in
# both orchestration modes — while the worker keeps its own copy. (A plain
# NAMESPACE key was restored alongside them by 03d854b7, then dropped again
# once helm-charts/charts/agent and the scopes repo confirmed nothing reads
# it — only K8S_NAMESPACE and NAMESPACE_OVERRIDE are ever consulted.)
#
# The agent's env renders as `    KEY: "value"` under configuration.values;
# the worker's renders through yamlencode as `"name": "KEY"`, so a match on
# "\n    KEY:" is specific to the agent container.
run "deploy_vars_reach_the_agent_env_with_orchestration_on" {
  command = plan

  variables {
    domain                  = "playground.nullapps.io"
    dns_type                = "external_dns"
    use_account_slug        = "true"
    image_pull_secrets      = "regcred"
    workload_namespace      = "nullplatform"
    service_template        = "/custom/service.yaml.tpl"
    initial_ingress_path    = "/custom/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/custom/blue-green-httproute.yaml.tpl"
  }

  assert {
    condition = alltrue([
      for key, want in {
        DOMAIN                  = "playground.nullapps.io"
        DNS_TYPE                = "external_dns"
        USE_ACCOUNT_SLUG        = "true"
        IMAGE_PULL_SECRETS      = "regcred"
        SERVICE_TEMPLATE        = "/custom/service.yaml.tpl"
        INITIAL_INGRESS_PATH    = "/custom/initial-httproute.yaml.tpl"
        BLUE_GREEN_INGRESS_PATH = "/custom/blue-green-httproute.yaml.tpl"
        CLUSTER_NAME            = "test-cluster"
        K8S_NAMESPACE           = "nullplatform"
      } :
      strcontains(helm_release.agent.values[0], "\n    ${key}: \"${want}\"")
    ])
    error_message = "the deploy/DNS vars must be back in the agent pod's own configuration.values"
  }

  # The worker patch is untouched by the restore: it still carries its own copy.
  assert {
    condition = alltrue([
      for key, want in {
        DOMAIN           = "playground.nullapps.io"
        DNS_TYPE         = "external_dns"
        K8S_NAMESPACE    = "nullplatform"
        SERVICE_TEMPLATE = "/custom/service.yaml.tpl"
      } :
      anytrue([
        for p in yamldecode(helm_release.agent.values[0]).worker.patches :
        anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == key && e.value == want])
        if try(p.target.package, "") == "containers"
      ])
    ])
    error_message = "restoring the agent's env must not take anything away from the worker's"
  }

  assert {
    condition     = can(yamldecode(helm_release.agent.values[0]))
    error_message = "the rendered values must be valid YAML with worker orchestration on"
  }
}

run "deploy_vars_reach_the_agent_env_with_orchestration_off" {
  command = plan

  variables {
    worker_orchestrator = false
    domain              = "playground.nullapps.io"
    dns_type            = "external_dns"
    use_account_slug    = "true"
    image_pull_secrets  = "regcred"
    workload_namespace  = "nullplatform"
  }

  assert {
    condition = alltrue([
      for key, want in {
        DOMAIN             = "playground.nullapps.io"
        DNS_TYPE           = "external_dns"
        USE_ACCOUNT_SLUG   = "true"
        IMAGE_PULL_SECRETS = "regcred"
        CLUSTER_NAME       = "test-cluster"
        K8S_NAMESPACE      = "nullplatform"
      } :
      strcontains(helm_release.agent.values[0], "\n    ${key}: \"${want}\"")
    ])
    error_message = "the agent's deploy/DNS env must not depend on worker orchestration being on"
  }
}

################################################################################
# worker_orchestrator toggle
################################################################################

# With the toggle off the module must write no worker configuration at all, so
# the chart's own worker defaults apply and no pod is patched. var.worker and
# the package lists are ignored while it is off.
run "worker_orchestrator_false_emits_no_worker_key" {
  command = plan

  variables {
    worker_orchestrator          = false
    worker_orchestrated_packages = ["containers", "aws-s3-bucket"]
    worker_k8s_packages          = ["containers", "scheduled-task"]
    worker = {
      idleTTL           = "1h"
      allowedRegistries = ["123456789012.dkr.ecr.us-east-1.amazonaws.com/my-org/*"]
      patches           = [{ target = { package = "my-pkg" }, merge = { spec = { serviceAccountName = "np-agent-sa" } } }]
    }
  }

  assert {
    condition     = can(yamldecode(helm_release.agent.values[0]))
    error_message = "the rendered values must be valid YAML with worker orchestration off"
  }

  assert {
    condition     = try(yamldecode(helm_release.agent.values[0]).worker, null) == null
    error_message = "worker_orchestrator = false must emit no top-level worker key, so the chart's own defaults apply"
  }

  assert {
    condition = (
      !strcontains(helm_release.agent.values[0], "patches") &&
      !strcontains(helm_release.agent.values[0], "idleTTL") &&
      !strcontains(helm_release.agent.values[0], "allowedRegistries") &&
      !strcontains(helm_release.agent.values[0], "my-pkg")
    )
    error_message = "worker_orchestrator = false must build no patches and pass nothing from var.worker through"
  }

  # The agent container itself is untouched by the toggle.
  assert {
    condition = (
      strcontains(helm_release.agent.values[0], "\n    NP_API_KEY: \"test-api-key\"") &&
      strcontains(helm_release.agent.values[0], "\n    IMAGE_TAG: \"0.9.2\"")
    )
    error_message = "the agent's own configuration.values must still render with worker orchestration off"
  }
}

run "worker_orchestrator_true_renders_the_block_and_patches" {
  command = plan

  assert {
    condition = (
      try(yamldecode(helm_release.agent.values[0]).worker.backend, "") == "kubernetes" &&
      length(try(yamldecode(helm_release.agent.values[0]).worker.patches, [])) > 0
    )
    error_message = "worker_orchestrator = true must render the worker block and its patches"
  }
}

################################################################################
# Worker disruption protection
################################################################################

# Workers run the actions, so evicting one fails the action in flight. An empty
# target makes the chart apply the patch to every worker, whatever its package.
run "workers_are_protected_from_autoscaler_evictions_by_default" {
  command = plan

  assert {
    condition = yamldecode(helm_release.agent.values[0]).worker.patches[0] == {
      target = {}
      merge = { metadata = { annotations = {
        "karpenter.sh/do-not-disrupt"                    = "true"
        "cluster-autoscaler.kubernetes.io/safe-to-evict" = "false"
      } } }
    }
    error_message = "the first worker patch must target every worker and carry the autoscaler annotations"
  }

  assert {
    condition = length([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches : p
      if try(p.merge.metadata.annotations, null) != null
    ]) == 1
    error_message = "the annotations must come from a single patch, not be repeated per package"
  }
}

run "worker_annotation_set_to_null_is_rendered_as_null" {
  command = plan

  variables {
    worker_pod_annotations = { "karpenter.sh/do-not-disrupt" = null, team = "platform" }
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).worker.patches[0].merge.metadata.annotations == { "karpenter.sh/do-not-disrupt" = null, team = "platform" }
    error_message = "worker_pod_annotations must be rendered as given, null included"
  }
}

run "empty_worker_annotations_render_no_patch" {
  command = plan

  variables {
    worker_pod_annotations = {}
  }

  assert {
    condition = length([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches : p
      if try(p.merge.metadata.annotations, null) != null
    ]) == 0
    error_message = "an empty worker_pod_annotations must not render the annotation patch"
  }
}

################################################################################
# Agent and worker resources
################################################################################

# The chart owns the resources: by default the module renders none, for the
# agent or for the workers.
run "resources_default_to_the_chart" {
  command = plan

  assert {
    condition     = try(yamldecode(helm_release.agent.values[0]).resources, null) == null
    error_message = "by default the module must not render the agent's resources"
  }

  assert {
    condition = length([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches : p
      if try(p.merge.spec.containers[0].resources, null) != null
    ]) == 0
    error_message = "by default no worker patch may set resources"
  }
}

run "agent_resources_are_overridable" {
  command = plan

  variables {
    resources = { requests = { cpu = "1", memory = "4Gi" }, limits = { memory = "4Gi" } }
  }

  assert {
    condition = yamldecode(helm_release.agent.values[0]).resources == {
      requests = { cpu = "1", memory = "4Gi" }
      limits   = { memory = "4Gi" }
    }
    error_message = "resources must be rendered as given"
  }
}

run "agent_resources_empty_renders_nothing" {
  command = plan

  variables {
    resources = { requests = {}, limits = {} }
  }

  assert {
    condition     = try(yamldecode(helm_release.agent.values[0]).resources, null) == null
    error_message = "empty requests and limits must leave the chart's resources untouched"
  }
}

# Second patch, right after the annotations: it targets every worker, so all
# of them get the same resources whatever their package.
run "worker_resources_target_every_worker" {
  command = plan

  variables {
    worker_resources = { requests = { cpu = "500m" }, limits = { memory = "4Gi" } }
  }

  assert {
    condition = yamldecode(helm_release.agent.values[0]).worker.patches[1] == {
      target = {}
      merge = { spec = { containers = [{
        name      = "worker"
        resources = { requests = { cpu = "500m" }, limits = { memory = "4Gi" } }
      }] } }
    }
    error_message = "worker_resources must render as a single patch with an empty target"
  }
}

run "worker_resources_are_overridable" {
  command = plan

  variables {
    worker_resources = { requests = { cpu = "250m" } }
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).worker.patches[1].merge.spec.containers[0].resources == { requests = { cpu = "250m" } }
    error_message = "worker_resources must be rendered as given, empty maps dropped"
  }
}

run "worker_resources_empty_renders_no_patch" {
  command = plan

  variables {
    worker_resources = { requests = {}, limits = {} }
  }

  assert {
    condition = length([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches : p
      if try(p.target.package, null) == null && try(p.merge.spec.containers[0].resources, null) != null
    ]) == 0
    error_message = "empty requests and limits must not render the base resources patch"
  }
}

run "extra_envs_reaches_the_agent_with_orchestration_off" {
  command = plan

  variables {
    worker_orchestrator = false
    extra_envs          = { MY_VAR = "my-value" }
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\n    MY_VAR: \"my-value\"")
    error_message = "extra_envs must keep reaching the agent with worker orchestration off"
  }
}

################################################################################
# Per-cloud variables on the agent container
################################################################################

# 34238fd2 left cloud_config empty for gcp/azure/oci, so on those clouds the
# per-cloud values reached neither the agent nor (for gcp/oci) anything else.
run "azure_cloud_vars_reach_the_agent_env" {
  command = plan

  variables {
    cloud_provider         = "azure"
    aws_iam_role_arn       = ""
    cluster_name           = ""
    azure_client_id        = "azure-client-id"
    azure_client_secret    = "azure-client-secret"
    azure_subscription_id  = "azure-subscription-id"
    azure_resource_group   = "azure-rg"
    azure_tenant_id        = "azure-tenant-id"
    private_hosted_zone_rg = "azure-dns-rg"
  }

  assert {
    condition = alltrue([
      for key, want in {
        PRIVATE_HOSTED_ZONE_RG = "azure-dns-rg"
        PRIVATE_GATEWAY_NAME   = "gateway-private"
        PUBLIC_GATEWAY_NAME    = "gateway-public"
        RESOURCE_GROUP         = "azure-rg"
        AZURE_SUBSCRIPTION_ID  = "azure-subscription-id"
        AZURE_CLIENT_SECRET    = "azure-client-secret"
        AZURE_CLIENT_ID        = "azure-client-id"
        AZURE_TENANT_ID        = "azure-tenant-id"
      } :
      strcontains(helm_release.agent.values[0], "\n    ${key}: \"${want}\"")
    ])
    error_message = "the azure agent env must carry the values it had before 34238fd2"
  }
}

run "gcp_cloud_vars_reach_the_agent_env" {
  command = plan

  variables {
    cloud_provider       = "gcp"
    aws_iam_role_arn     = ""
    cluster_name         = ""
    private_gateway_name = "gcp-gateway-private"
    public_gateway_name  = "gcp-gateway-public"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\n    PRIVATE_GATEWAY_NAME: \"gcp-gateway-private\"")
    error_message = "gcp must get PRIVATE_GATEWAY_NAME in the agent env again"
  }

  # PRIVATE_GATEWAY_NAME/PUBLIC_GATEWAY_NAME moved into shared_deploy_config,
  # sent to the agent's own env unconditionally regardless of cloud_provider —
  # same as the worker's env always carried them.
  assert {
    condition     = strcontains(helm_release.agent.values[0], "\n    PUBLIC_GATEWAY_NAME: \"gcp-gateway-public\"")
    error_message = "gcp must also get PUBLIC_GATEWAY_NAME in the agent env, same as every other cloud"
  }
}

run "oci_cloud_vars_reach_the_agent_env" {
  command = plan

  variables {
    cloud_provider       = "oci"
    aws_iam_role_arn     = ""
    cluster_name         = ""
    private_gateway_name = "oci-gateway-private"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\n    PRIVATE_GATEWAY_NAME: \"oci-gateway-private\"")
    error_message = "oci must get PRIVATE_GATEWAY_NAME in the agent env again"
  }
}

################################################################################
# Agent image pull secret
################################################################################

# The chart pulls the agent image anonymously unless it is told which secret to
# use. That is fine while the image comes from the public repository, and breaks
# the moment an install mirrors it into a registry of its own.
run "agent_image_pull_secret_is_referenced_when_named" {
  command = plan

  variables {
    image_pull_secret_name = "image-pull-secret-agent"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).imagePullSecret.name == "image-pull-secret-agent"
    error_message = "the agent's pull secret should reach the chart by name"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).imagePullSecret.create == false
    error_message = "the secret belongs to whoever owns the registry credentials: the chart must reference it, not create it"
  }

  # yamldecode is blind to blank lines, so the two asserts above still pass if the
  # template's trim markers are dropped. This one pins the bytes around the block.
  assert {
    condition     = strcontains(helm_release.agent.values[0], "image:\n  tag: \"0.9.2\"\n  \n\nimagePullSecret:\n  create: false\n  name: \"image-pull-secret-agent\"\n\n  \n\nworker:\n")
    error_message = "the imagePullSecret block must render with exactly the whitespace the trim markers produce"
  }
}

# Left unset the block must not render at all: an imagePullSecret with an empty
# name is not the same as no imagePullSecret, and every install pulling a public
# image today passes through here.
run "agent_image_pull_secret_is_absent_by_default" {
  command = plan

  assert {
    condition     = !can(yamldecode(helm_release.agent.values[0]).imagePullSecret)
    error_message = "without a name, nothing about imagePullSecret should be rendered"
  }

  # The guard has to be a clean no-op, not a blank line: every install that pulls
  # a public image renders this path, and a stray newline is a free helm upgrade
  # for all of them. yamldecode cannot see it, so pin the bytes.
  assert {
    condition     = strcontains(helm_release.agent.values[0], "image:\n  tag: \"0.9.2\"\n  \n\n  \n\nworker:\n")
    error_message = "the imagePullSecret guard must leave the rendered document unchanged when no name is given"
  }
}

# image_pull_secrets and image_pull_secret_name are one character apart and sit
# next to each other, yet feed unrelated places: this one the workers' env, the
# other the agent's own image. Nothing else in the suite keeps them apart.
run "agent_and_workload_pull_secrets_do_not_cross_wire" {
  command = plan

  variables {
    image_pull_secret_name = "image-pull-secret-agent"
    image_pull_secrets     = "{\"ENABLED\":true,\"SECRETS\":[\"image-pull-secret-workload\"]}"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).imagePullSecret.name == "image-pull-secret-agent"
    error_message = "the agent's own pull secret must come from image_pull_secret_name"
  }

  assert {
    condition = anytrue([
      for p in yamldecode(helm_release.agent.values[0]).worker.patches :
      anytrue([for e in try(p.merge.spec.containers[0].env, []) : e.name == "IMAGE_PULL_SECRETS" && e.value == "{\"ENABLED\":true,\"SECRETS\":[\"image-pull-secret-workload\"]}"])
      if try(p.target.package, "") == "containers"
    ])
    error_message = "the workload pull secrets must reach the worker as IMAGE_PULL_SECRETS, unchanged"
  }

  assert {
    condition     = !strcontains(jsonencode(yamldecode(helm_release.agent.values[0]).imagePullSecret), "image-pull-secret-workload")
    error_message = "the workload pull secrets must never leak into the agent's own imagePullSecret block"
  }
}

################################################################################
# Probe overrides
################################################################################

# Off by default: nothing is rendered, so the chart keeps its own probes and an
# existing install sees no diff.
run "probes_are_left_to_the_chart_by_default" {
  command = plan

  assert {
    condition     = !strcontains(helm_release.agent.values[0], "livenessProbe") && !strcontains(helm_release.agent.values[0], "readinessProbe")
    error_message = "with no overrides the module must not render any probe key"
  }
}

# Only the given fields are rendered: helm merges them over the chart's probe,
# so its httpGet /health on 8080 stays.
run "probe_overrides_are_rendered" {
  command = plan

  variables {
    liveness_probe  = { initialDelaySeconds = 120, failureThreshold = 6 }
    readiness_probe = { initialDelaySeconds = 60 }
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "livenessProbe:\n  \"failureThreshold\": 6\n  \"initialDelaySeconds\": 120")
    error_message = "liveness_probe must render under livenessProbe"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "readinessProbe:\n  \"initialDelaySeconds\": 60")
    error_message = "readiness_probe must render under readinessProbe"
  }

  assert {
    condition     = !strcontains(helm_release.agent.values[0], "httpGet")
    error_message = "the module must not restate the chart's httpGet; only the given fields are rendered"
  }
}

################################################################################
# Disruption protection (chart >= 3.2.0)
################################################################################

# The chart carries the defaults (autoscaler annotations, startupProbe, grace
# period); the module renders nothing unless asked, so an existing install sees
# no diff and the chart stays the single source of those defaults.
run "disruption_settings_are_left_to_the_chart_by_default" {
  command = plan

  assert {
    condition = alltrue([
      for key in ["startupProbe", "podAnnotations", "terminationGracePeriodSeconds", "shutdownDrainTimeoutSeconds", "podDisruptionBudget", "nodeSelector", "tolerations", "replicaCount", "affinity"] :
      !contains(keys(yamldecode(helm_release.agent.values[0])), key)
    ])
    error_message = "with no overrides the module must not render any disruption-related key"
  }
}

run "disruption_overrides_are_rendered" {
  command = plan

  variables {
    startup_probe                    = { failureThreshold = 60 }
    pod_annotations                  = { team = "platform" }
    termination_grace_period_seconds = 120
    shutdown_drain_timeout_seconds   = 90
    pod_disruption_budget            = { enabled = true, maxUnavailable = 1 }
    node_selector                    = { "karpenter.sh/nodepool" = "platform" }
    tolerations = [
      { key = "dedicated", operator = "Equal", value = "platform", effect = "NoSchedule" },
      { key = "node.kubernetes.io/unreachable", operator = "Exists", effect = "NoExecute", tolerationSeconds = 300 },
    ]
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).startupProbe == { failureThreshold = 60 }
    error_message = "startup_probe must render only its own fields under startupProbe, so helm merges them over the chart's httpGet"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).podAnnotations == { team = "platform" }
    error_message = "pod_annotations must render under podAnnotations"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).terminationGracePeriodSeconds == 120
    error_message = "termination_grace_period_seconds must render as a number"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).shutdownDrainTimeoutSeconds == 90
    error_message = "shutdown_drain_timeout_seconds must render as a number under shutdownDrainTimeoutSeconds"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).podDisruptionBudget == { enabled = true, maxUnavailable = 1 }
    error_message = "pod_disruption_budget must render under podDisruptionBudget"
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).nodeSelector == { "karpenter.sh/nodepool" = "platform" }
    error_message = "node_selector must render under nodeSelector"
  }

  assert {
    condition     = length(yamldecode(helm_release.agent.values[0]).tolerations) == 2 && yamldecode(helm_release.agent.values[0]).tolerations[1].tolerationSeconds == 300
    error_message = "tolerations with different keys must render as-is under tolerations"
  }
}

# Helm deletes a chart default when the override is null: this is how an
# install drops one of the chart's autoscaler annotations.
run "pod_annotation_set_to_null_drops_the_chart_default" {
  command = plan

  variables {
    pod_annotations = { "karpenter.sh/do-not-disrupt" = null }
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"karpenter.sh/do-not-disrupt\": null")
    error_message = "a null annotation must render as null so helm removes the chart's default"
  }
}

run "termination_grace_period_must_outlast_the_prestop_sleep" {
  command = plan

  variables {
    termination_grace_period_seconds = 30
  }

  expect_failures = [var.termination_grace_period_seconds]
}

run "shutdown_drain_must_fit_in_the_grace_period" {
  command = plan

  variables {
    termination_grace_period_seconds = 60
    shutdown_drain_timeout_seconds   = 55
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "shutdown_drain_must_be_whole_seconds" {
  command = plan

  variables {
    shutdown_drain_timeout_seconds = 1.5
  }

  expect_failures = [var.shutdown_drain_timeout_seconds]
}

run "tolerations_must_be_a_list" {
  command = plan

  variables {
    tolerations = { key = "dedicated", operator = "Exists" }
  }

  expect_failures = [var.tolerations]
}

run "replicas_and_affinity_are_rendered" {
  command = plan

  variables {
    replicas = 4
    affinity = {
      podAntiAffinity = {
        requiredDuringSchedulingIgnoredDuringExecution = [
          {
            labelSelector = { matchLabels = { "app.kubernetes.io/name" = "nullplatform-agent" } }
            topologyKey   = "kubernetes.io/hostname"
          },
        ]
      }
    }
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).replicaCount == 4
    error_message = "replicas must render as a number under replicaCount"
  }

  assert {
    condition     = jsonencode(yamldecode(helm_release.agent.values[0]).affinity) == jsonencode(var.affinity)
    error_message = "affinity must render as-is under affinity"
  }
}

run "replicas_must_be_at_least_one" {
  command = plan

  variables {
    replicas = 0
  }

  expect_failures = [var.replicas]
}

run "a_single_replica_is_accepted" {
  command = plan

  variables {
    replicas = 1
  }

  assert {
    condition     = yamldecode(helm_release.agent.values[0]).replicaCount == 1
    error_message = "the lower bound of one replica must be accepted and rendered"
  }
}

run "replicas_must_be_whole" {
  command = plan

  variables {
    replicas = 1.5
  }

  expect_failures = [var.replicas]
}

run "affinity_must_be_an_object" {
  command = plan

  variables {
    affinity = [{ topologyKey = "kubernetes.io/hostname" }]
  }

  expect_failures = [var.affinity]
}

run "azure_workload_identity_labels_the_agent_and_its_workers" {
  command = plan

  variables {
    cloud_provider               = "azure"
    aws_iam_role_arn             = ""
    cluster_name                 = ""
    azure_workload_identity      = true
    azure_subscription_id        = "azure-subscription-id"
    azure_resource_group         = "azure-rg"
    azure_tenant_id              = "azure-tenant-id"
    private_hosted_zone_rg       = "azure-dns-rg"
    worker_orchestrated_packages = ["containers", "aks"]
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "podLabels:\n  \"azure.workload.identity/use\": \"true\"")
    error_message = "the agent pod must carry the azure.workload.identity/use label"
  }

  assert {
    condition     = length(regexall("\"azure.workload.identity/use\": \"true\"", helm_release.agent.values[0])) == 3
    error_message = "the label must appear once for the agent and once per worker-orchestrated package (here 1 + 2)"
  }

  assert {
    condition     = !strcontains(helm_release.agent.values[0], "AZURE_CLIENT_SECRET")
    error_message = "with workload identity and no secret, AZURE_CLIENT_SECRET must not be rendered"
  }

  assert {
    condition     = !strcontains(helm_release.agent.values[0], "azure.workload.identity/client-id")
    error_message = "without azure_client_id the ServiceAccount must not get a client-id annotation"
  }
}

run "azure_workload_identity_coexists_with_the_client_secret" {
  command = plan

  variables {
    cloud_provider          = "azure"
    aws_iam_role_arn        = ""
    cluster_name            = ""
    azure_workload_identity = true
    azure_client_id         = "azure-client-id"
    azure_client_secret     = "azure-client-secret"
    azure_subscription_id   = "azure-subscription-id"
    azure_resource_group    = "azure-rg"
    azure_tenant_id         = "azure-tenant-id"
    private_hosted_zone_rg  = "azure-dns-rg"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"azure.workload.identity/use\": \"true\"") && strcontains(helm_release.agent.values[0], "\n    AZURE_CLIENT_SECRET: \"azure-client-secret\"")
    error_message = "the label and the legacy secret must both render while migrating"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "azure.workload.identity/client-id: \"azure-client-id\"")
    error_message = "the ServiceAccount must be annotated with the client ID while the Service Principal is still set"
  }
}

run "azure_without_workload_identity_renders_no_label" {
  command = plan

  variables {
    cloud_provider         = "azure"
    aws_iam_role_arn       = ""
    cluster_name           = ""
    azure_client_id        = "azure-client-id"
    azure_client_secret    = "azure-client-secret"
    azure_subscription_id  = "azure-subscription-id"
    azure_resource_group   = "azure-rg"
    azure_tenant_id        = "azure-tenant-id"
    private_hosted_zone_rg = "azure-dns-rg"
  }

  assert {
    condition     = !strcontains(helm_release.agent.values[0], "azure.workload.identity") && !strcontains(helm_release.agent.values[0], "podLabels")
    error_message = "azure_workload_identity = false must not add any label"
  }
}

run "azure_workload_identity_is_ignored_off_azure" {
  command = plan

  variables {
    azure_workload_identity = true
  }

  assert {
    condition     = !strcontains(helm_release.agent.values[0], "azure.workload.identity")
    error_message = "the label must only be added when cloud_provider is azure"
  }
}

run "azure_requires_workload_identity_or_a_client_secret" {
  command = plan

  variables {
    cloud_provider         = "azure"
    aws_iam_role_arn       = ""
    cluster_name           = ""
    azure_client_id        = "azure-client-id"
    azure_subscription_id  = "azure-subscription-id"
    azure_resource_group   = "azure-rg"
    azure_tenant_id        = "azure-tenant-id"
    private_hosted_zone_rg = "azure-dns-rg"
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "azure_client_secret_without_client_id_is_rejected" {
  command = plan

  variables {
    cloud_provider          = "azure"
    aws_iam_role_arn        = ""
    cluster_name            = ""
    azure_workload_identity = true
    azure_client_secret     = "azure-client-secret"
    azure_subscription_id   = "azure-subscription-id"
    azure_resource_group    = "azure-rg"
    azure_tenant_id         = "azure-tenant-id"
    private_hosted_zone_rg  = "azure-dns-rg"
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "azure_workload_identity_requires_a_service_account_name" {
  command = plan

  variables {
    cloud_provider          = "azure"
    aws_iam_role_arn        = ""
    cluster_name            = ""
    azure_workload_identity = true
    service_account_name    = ""
    azure_subscription_id   = "azure-subscription-id"
    azure_resource_group    = "azure-rg"
    azure_tenant_id         = "azure-tenant-id"
    private_hosted_zone_rg  = "azure-dns-rg"
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "azure_workload_identity_without_worker_orchestrator_labels_only_the_agent" {
  command = plan

  variables {
    cloud_provider          = "azure"
    aws_iam_role_arn        = ""
    cluster_name            = ""
    azure_workload_identity = true
    worker_orchestrator     = false
    azure_subscription_id   = "azure-subscription-id"
    azure_resource_group    = "azure-rg"
    azure_tenant_id         = "azure-tenant-id"
    private_hosted_zone_rg  = "azure-dns-rg"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "podLabels:")
    error_message = "the agent pod must still carry podLabels with the orchestrator off"
  }

  assert {
    condition     = length(regexall("\"azure.workload.identity/use\": \"true\"", helm_release.agent.values[0])) == 1
    error_message = "the label must render exactly once (agent only) with worker_orchestrator = false"
  }
}
