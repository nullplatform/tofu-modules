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
