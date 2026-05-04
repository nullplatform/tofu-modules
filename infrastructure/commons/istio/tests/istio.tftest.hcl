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

  assert {
    condition     = helm_release.istio_ingressgateway.namespace == "istio-system"
    error_message = "Ingress gateway should deploy to istio-system namespace"
  }
}

# Validates all three components have correct chart names
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

  assert {
    condition     = helm_release.istio_ingressgateway.chart == "gateway"
    error_message = "Ingress gateway chart should be 'gateway'"
  }
}

# Validates consistent versions across all components
run "consistent_versions" {
  command = plan

  variables {
    istio_base_version           = "1.27.1"
    istiod_version               = "1.27.1"
    istio_ingressgateway_version = "1.27.1"
  }

  assert {
    condition     = helm_release.istio_base.version == "1.27.1"
    error_message = "Istio base version should match"
  }

  assert {
    condition     = helm_release.istiod.version == "1.27.1"
    error_message = "Istiod version should match"
  }

  assert {
    condition     = helm_release.istio_ingressgateway.version == "1.27.1"
    error_message = "Ingress gateway version should match"
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

  assert {
    condition     = helm_release.istio_ingressgateway.namespace == "custom-istio"
    error_message = "Ingress gateway should use custom namespace"
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

  assert {
    condition     = helm_release.istio_ingressgateway.atomic == true
    error_message = "Ingress gateway should use atomic deployment"
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

# Backward-compat: with the default (null), the module must NOT inject any
# `pilot.replicaCount` override. Existing consumers see no behavior change
# after upgrading.
run "istiod_default_no_replica_count_override" {
  command = plan

  assert {
    condition     = length(helm_release.istiod.set) == 0
    error_message = "Default istiod_replica_count must be null and produce no `set` entries (backward-compat)"
  }
}

# Opt-in: when the operator sets a value, it is forwarded to the Helm chart
# as `pilot.replicaCount`.
run "istiod_custom_replica_count" {
  command = plan

  variables {
    istiod_replica_count = 2
  }

  assert {
    condition     = length(helm_release.istiod.set) == 1
    error_message = "Setting istiod_replica_count should produce exactly one `set` entry"
  }

  assert {
    condition     = helm_release.istiod.set[0].name == "pilot.replicaCount"
    error_message = "istiod helm release should set pilot.replicaCount"
  }

  assert {
    condition     = helm_release.istiod.set[0].value == "2"
    error_message = "Custom istiod_replica_count should be forwarded as pilot.replicaCount"
  }
}
