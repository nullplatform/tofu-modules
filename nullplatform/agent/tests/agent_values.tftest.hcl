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
