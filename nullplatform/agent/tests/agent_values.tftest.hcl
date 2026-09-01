mock_provider "helm" {}
mock_provider "nullplatform" {}

variables {
  api_key                         = "test-api-key"
  cluster_name                    = "my-cluster"
  tags_selectors                  = { dimension = "prod" }
  cloud_provider                  = "aws"
  aws_iam_role_arn                = "arn:aws:iam::123456789012:role/agent"
  image_tag                       = "0.9.2"
  nullplatform_agent_helm_version = "2.37.0"
  agent_traffic_manager_tag       = "1.8.0"
  agent_repos_scope_tag           = "v1.15.1"
}

################################################################################
# Traffic manager image
################################################################################

# Pinning the traffic manager used to mean passing the whole image string through
# extra_envs. The registry now lives in the module and only the tag is exposed.
run "traffic_manager_image_is_assembled_from_the_tag" {
  command = plan

  assert {
    condition     = strcontains(helm_release.agent.values[0], "TRAFFIC_CONTAINER_IMAGE: \"public.ecr.aws/nullplatform/k8s-traffic-manager:1.8.0\"")
    error_message = "TRAFFIC_CONTAINER_IMAGE should be built from the repository default and the pinned tag"
  }
}

run "traffic_manager_repository_is_overridable" {
  command = plan

  variables {
    agent_traffic_manager_repository = "my-mirror.example.com/nullplatform/k8s-traffic-manager"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "TRAFFIC_CONTAINER_IMAGE: \"my-mirror.example.com/nullplatform/k8s-traffic-manager:1.8.0\"")
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

################################################################################
# Scope repository
################################################################################

run "scope_repo_is_pinned_to_a_tag" {
  command = plan

  assert {
    condition     = !strcontains(helm_release.agent.values[0], "#main")
    error_message = "the scope repo default must not point at a moving branch"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "scopes.git#v1.15.1")
    error_message = "the scope repo default should be pinned to the released tag"
  }
}

run "scope_repo_is_overridable" {
  command = plan

  variables {
    agent_repos_scope_tag = "v1.14.0"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "scopes.git#v1.14.0")
    error_message = "callers must still be able to choose their own ref"
  }
}

run "agent_repos_scope_rejects_an_inline_fragment" {
  command = plan

  variables {
    agent_repos_scope = "https://github.com/nullplatform/scopes.git#v1.15.1"
  }

  # Catches the most likely migration mistake: pasting the old value verbatim, which would
  # otherwise render repo.git#v1.15.1#v1.15.1.
  expect_failures = [var.agent_repos_scope]
}

################################################################################
# Worker orchestration
################################################################################

# DNS_TYPE/DOMAIN/USE_ACCOUNT_SLUG/SERVICE_TEMPLATE/INITIAL_INGRESS_PATH/
# BLUE_GREEN_INGRESS_PATH are consumed by the worker when it renders a scope's
# k8s deployment, not by the agent's own control loop — they live on the
# worker's env only. CLUSTER_NAME/NAMESPACE are needed by both. There is a
# single combined values document now (worker is just another top-level key
# of it, not a second Helm values layer), so "not in the agent's own config"
# is checked via the configuration.values rendering (`KEY: "value"`, no
# leading quote on the key) rather than absence from the whole document.
run "moved_deploy_vars_are_worker_only_cluster_and_namespace_are_shared" {
  command = plan

  variables {
    domain    = "playground.nullapps.io"
    dns_type  = "external_dns"
    namespace = "nullplatform"
  }

  assert {
    condition = alltrue([
      for key in ["DNS_TYPE", "DOMAIN", "USE_ACCOUNT_SLUG", "SERVICE_TEMPLATE",
      "INITIAL_INGRESS_PATH", "BLUE_GREEN_INGRESS_PATH"] :
      !strcontains(helm_release.agent.values[0], "\n    ${key}:")
    ])
    error_message = "deploy/DNS vars must not leak into the agent pod's own configuration.values"
  }

  assert {
    condition     = strcontains(helm_release.agent.values[0], "\n    CLUSTER_NAME:") && strcontains(helm_release.agent.values[0], "\n    NAMESPACE:")
    error_message = "CLUSTER_NAME and NAMESPACE must stay in the agent's own configuration.values"
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
      strcontains(helm_release.agent.values[0], "\"name\": \"CLUSTER_NAME\"")
    )
    error_message = "worker env must carry the deploy/DNS vars plus cluster/namespace"
  }
}

# backend/allowedRegistries have no dedicated variables — they're just keys
# on var.worker, same as idleTTL or any other chart field.
run "worker_backend_and_allowed_registries_are_overridable_via_var_worker" {
  command = plan

  variables {
    worker = {
      backend           = "nomad"
      allowedRegistries = ["public.ecr.aws/nullplatform/scopes*"]
    }
  }

  assert {
    condition = (
      strcontains(helm_release.agent.values[0], "\"backend\": \"nomad\"") &&
      strcontains(helm_release.agent.values[0], "public.ecr.aws/nullplatform/scopes*")
    )
    error_message = "var.worker.backend/allowedRegistries must override the module defaults"
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

run "worker_defaults" {
  command = plan

  assert {
    condition     = !strcontains(helm_release.agent.values[0], "allowedRegistries")
    error_message = "allowedRegistries must be omitted (not an empty list) when var.worker doesn't set it"
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
