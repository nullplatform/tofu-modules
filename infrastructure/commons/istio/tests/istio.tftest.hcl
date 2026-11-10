mock_provider "helm" {}

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
