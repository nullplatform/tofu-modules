mock_provider "helm" {}

variables {
  istio_base_version = "1.30.7"
  istiod_version     = "1.30.7"
}

# Validates Istio plans with default config
run "default_config" {
  command = plan

  assert {
    condition     = helm_release.istio_base.namespace == "istio-system"
    error_message = "Istio base should deploy to istio-system namespace"
  }

  assert {
    condition     = helm_release.istiod.namespace == "istio-system"
    error_message = "Istiod should deploy to istio-system namespace"
  }
}

# Validates both components have correct chart names
run "correct_chart_names" {
  command = plan

  assert {
    condition     = helm_release.istio_base.chart == "base"
    error_message = "Istio base chart should be 'base'"
  }

  assert {
    condition     = helm_release.istiod.chart == "istiod"
    error_message = "Istiod chart should be 'istiod'"
  }
}

# Validates consistent versions across all components
run "consistent_versions" {
  command = plan

  variables {
    istio_base_version = "1.27.1"
    istiod_version     = "1.27.1"
  }

  assert {
    condition     = helm_release.istio_base.version == "1.27.1"
    error_message = "Istio base version should match"
  }

  assert {
    condition     = helm_release.istiod.version == "1.27.1"
    error_message = "Istiod version should match"
  }
}

# Validates custom namespace is propagated to all components
run "custom_namespace" {
  command = plan

  variables {
    namespace = "custom-istio"
  }

  assert {
    condition     = helm_release.istio_base.namespace == "custom-istio"
    error_message = "Istio base should use custom namespace"
  }

  assert {
    condition     = helm_release.istiod.namespace == "custom-istio"
    error_message = "Istiod should use custom namespace"
  }
}

# Validates all releases use atomic deployments
run "atomic_deployments" {
  command = plan

  assert {
    condition     = helm_release.istio_base.atomic == true
    error_message = "Istio base should use atomic deployment"
  }

  assert {
    condition     = helm_release.istiod.atomic == true
    error_message = "Istiod should use atomic deployment"
  }
}

# Validates custom repository URL is propagated
run "custom_repository" {
  command = plan

  variables {
    repository = "https://custom-registry.example.com/charts"
  }

  assert {
    condition     = helm_release.istio_base.repository == "https://custom-registry.example.com/charts"
    error_message = "All components should use custom repository"
  }
}

# Validates the gateway access log provider is off by default
run "gateway_access_log_disabled_by_default" {
  command = plan

  assert {
    condition     = length(helm_release.istiod.values) == 0
    error_message = "istiod should get no extra values unless gateway_access_log_enabled is set"
  }
}

# Validates the access log provider the logs-controller expects
run "gateway_access_log_enabled" {
  command = plan

  variables {
    gateway_access_log_enabled = true
  }

  assert {
    condition     = yamldecode(helm_release.istiod.values[0]).meshConfig.extensionProviders[0].name == "np-gateway-access-log"
    error_message = "istiod meshConfig should declare the np-gateway-access-log provider"
  }

  assert {
    condition     = yamldecode(helm_release.istiod.values[0]).meshConfig.extensionProviders[0].envoyFileAccessLog.logFormat.labels.upstream_cluster == "%UPSTREAM_CLUSTER_RAW%"
    error_message = "the access log must be JSON (logFormat.labels) with the fields the logs-controller parses"
  }
}

# No default: an install that does not pin the charts must fail, not drift (CLIEN-1176)
run "rejects_moving_chart_versions" {
  command = plan

  variables {
    istio_base_version = ""
    istiod_version     = "latest"
  }

  expect_failures = [var.istio_base_version, var.istiod_version]
}

# Without image_hub the chart keeps its own image source
run "image_hub_unset_by_default" {
  command = plan

  assert {
    condition     = length([for s in helm_release.istiod.set : s if s.name == "global.hub"]) == 0
    error_message = "global.hub must not be set unless image_hub is given"
  }

  assert {
    condition = alltrue([
      for n in ["pilot.replicaCount", "pilot.autoscaleMin"] :
      length([for s in helm_release.istiod.set : s if s.name == n]) == 1
    ])
    error_message = "image_hub must not drop the replica and autoscale settings"
  }
}

# image_hub reaches istiod as global.hub, unmodified
run "image_hub_sets_global_hub" {
  command = plan

  variables {
    image_hub = "myregistry.example.com/mirror/istio"
  }

  assert {
    condition     = one([for s in helm_release.istiod.set : s.value if s.name == "global.hub"]) == "myregistry.example.com/mirror/istio"
    error_message = "image_hub should be passed to istiod as global.hub"
  }

  assert {
    condition = alltrue([
      for n in ["pilot.replicaCount", "pilot.autoscaleMin"] :
      length([for s in helm_release.istiod.set : s if s.name == n]) == 1
    ])
    error_message = "image_hub must not drop the replica and autoscale settings"
  }
}

# A hub carries no tag: the chart adds the version
run "image_hub_rejects_tag" {
  command = plan

  variables {
    image_hub = "docker.io/istio:1.0"
  }

  expect_failures = [var.image_hub]
}

# A bare host has no path: Istio images live under one
run "image_hub_rejects_bare_host" {
  command = plan

  variables {
    image_hub = "docker.io"
  }

  expect_failures = [var.image_hub]
}

# A private registry on a port, with a nested path
run "image_hub_accepts_registry_with_port" {
  command = plan

  variables {
    image_hub = "myreg.example.com:5000/mirror/istio"
  }

  assert {
    condition     = one([for s in helm_release.istiod.set : s.value if s.name == "global.hub"]) == "myreg.example.com:5000/mirror/istio"
    error_message = "a registry host:port with a nested path must be accepted and passed through"
  }
}

# Values people paste that would render a broken image reference
run "image_hub_rejects_url_scheme" {
  command = plan

  variables {
    image_hub = "https://docker.io/istio"
  }

  expect_failures = [var.image_hub]
}

run "image_hub_rejects_trailing_slash" {
  command = plan

  variables {
    image_hub = "docker.io/istio/"
  }

  expect_failures = [var.image_hub]
}

run "image_hub_rejects_digest" {
  command = plan

  variables {
    image_hub = "docker.io/istio@sha256:0123456789abcdef"
  }

  expect_failures = [var.image_hub]
}

# Without image_pull_secrets the chart keeps its own setting
run "image_pull_secrets_unset_by_default" {
  command = plan

  assert {
    condition     = length(coalesce(helm_release.istiod.set_list, [])) == 0
    error_message = "global.imagePullSecrets must not be set unless image_pull_secrets is given"
  }
}

# image_pull_secrets reaches istiod as global.imagePullSecrets, in order
run "image_pull_secrets_sets_global_list" {
  command = plan

  variables {
    image_hub          = "myreg.example.com/mirror/istio"
    image_pull_secrets = ["mirror-pull", "mirror-pull-2"]
  }

  assert {
    condition     = one([for s in helm_release.istiod.set_list : s.value if s.name == "global.imagePullSecrets"]) == tolist(["mirror-pull", "mirror-pull-2"])
    error_message = "image_pull_secrets should be passed to istiod as global.imagePullSecrets"
  }
}

run "image_pull_secrets_rejects_invalid_name" {
  command = plan

  variables {
    image_pull_secrets = ["Mirror_Pull"]
  }

  expect_failures = [var.image_pull_secrets]
}

# null means "not set", as for image_hub, instead of breaking the plan
run "image_pull_secrets_accepts_null" {
  command = plan

  variables {
    image_pull_secrets = null
  }

  assert {
    condition     = length(coalesce(helm_release.istiod.set_list, [])) == 0
    error_message = "a null image_pull_secrets should behave like the empty default"
  }
}
