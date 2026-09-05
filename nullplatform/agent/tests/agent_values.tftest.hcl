mock_provider "helm" {}
mock_provider "nullplatform" {}

variables {
  api_key                         = "test-api-key"
  tags_selectors                  = { dimension = "prod" }
  cloud_provider                  = "aws"
  aws_iam_role_arn                = "arn:aws:iam::123456789012:role/agent"
  image_tag                       = "0.9.2"
  nullplatform_agent_helm_version = "2.37.0"
  agent_traffic_manager_tag       = "1.8.0"
}

################################################################################
# Traffic manager image
################################################################################

# Pinning the traffic manager used to mean passing the whole image string through
# extra_envs. The registry now lives in the module and only the tag is exposed.
# TRAFFIC_CONTAINER_IMAGE is a worker-only var (worker_default_env), so it
# renders as an env list entry, not a flat configuration.values key.
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

# DNS_TYPE/DOMAIN/USE_ACCOUNT_SLUG/SERVICE_TEMPLATE/INITIAL_INGRESS_PATH/
# BLUE_GREEN_INGRESS_PATH are consumed by the worker when it renders a scope's
# k8s deployment, not by the agent's own control loop — they live on the
# worker's env only (worker_default_env), never in the agent's own
# configuration.values (default_config).
run "moved_deploy_vars_are_worker_only" {
  command = plan

  variables {
    domain    = "playground.nullapps.io"
    dns_type  = "external_dns"
    namespace = "nullplatform"
  }

  assert {
    condition = alltrue([
      for key in ["DNS_TYPE", "DOMAIN", "USE_ACCOUNT_SLUG", "SERVICE_TEMPLATE",
      "INITIAL_INGRESS_PATH", "BLUE_GREEN_INGRESS_PATH", "NAMESPACE"] :
      !strcontains(helm_release.agent.values[0], "\n    ${key}:")
    ])
    error_message = "deploy/DNS vars and NAMESPACE must not leak into the agent pod's own configuration.values"
  }
}

run "worker_block_always_present_with_expected_env" {
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

  assert {
    condition     = length(regexall("\"memory\": \"2Gi\"", helm_release.agent.values[0])) == 2
    error_message = "each package in worker_orchestrated_packages must get its own memory limit patch (one per package, here 2) — a package left out would silently OOM on the chart's thin default"
  }
}

run "worker_memory_limit_is_overridable" {
  command = plan

  variables {
    worker_orchestrated_packages = ["containers", "aws-s3-bucket"]
    worker_memory_limit          = "4Gi"
  }

  assert {
    condition     = length(regexall("\"memory\": \"4Gi\"", helm_release.agent.values[0])) == 2
    error_message = "worker_memory_limit must apply to every package in worker_orchestrated_packages"
  }
}

run "worker_defaults" {
  command = plan

  assert {
    condition     = strcontains(helm_release.agent.values[0], "public.ecr.aws/nullplatform/*")
    error_message = "allowedRegistries must default to public.ecr.aws/nullplatform/* so the platform's own scope images keep pulling"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"memory\": \"2Gi\"")
    error_message = "the worker container's memory limit must default to 2Gi"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\"serviceAccountName\": \"nullplatform-agent\"")
    error_message = "the worker's serviceAccountName must default to service_account_name's default (nullplatform-agent)"
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
