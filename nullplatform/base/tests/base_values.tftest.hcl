mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  np_api_key   = "test-api-key"
  k8s_provider = "eks"
}

############################################
# applicationLogs toggle
############################################

run "application_logs_enabled_by_default" {
  command = plan

  assert {
    condition     = strcontains(output.rendered_values, "applicationLogs:")
    error_message = "rendered values must include applicationLogs section"
  }

  assert {
    condition     = strcontains(output.rendered_values, "enabled: true\n  mountDockerContainers")
    error_message = "applicationLogs.enabled should default to true"
  }
}

run "application_logs_disabled" {
  command = plan

  variables {
    logging_application_logs_enabled = false
  }

  assert {
    condition     = strcontains(output.rendered_values, "enabled: false\n  mountDockerContainers")
    error_message = "applicationLogs.enabled should be false when disabled"
  }
}

############################################
# mountDockerContainers toggle
############################################

run "mount_docker_containers_disabled_by_default" {
  command = plan

  assert {
    condition     = strcontains(output.rendered_values, "mountDockerContainers: false")
    error_message = "mountDockerContainers should default to false"
  }
}

run "mount_docker_containers_enabled" {
  command = plan

  variables {
    logging_mount_docker_containers = true
  }

  assert {
    condition     = strcontains(output.rendered_values, "mountDockerContainers: true")
    error_message = "mountDockerContainers should be true when enabled"
  }
}

############################################
# Datadog logs/metrics split
############################################

run "datadog_logs_and_metrics_enabled_by_default" {
  command = plan

  variables {
    datadog_enabled = true
    datadog_api_key = "dd-test-key"
  }

  assert {
    condition     = strcontains(output.rendered_values, "logsEnabled: true\n    metricsEnabled: true\n    apiKey: \"dd-test-key\"")
    error_message = "datadog logsEnabled and metricsEnabled should both default to true"
  }
}

run "datadog_logs_disabled" {
  command = plan

  variables {
    datadog_enabled      = true
    datadog_api_key      = "dd-test-key"
    datadog_logs_enabled = false
  }

  assert {
    condition     = strcontains(output.rendered_values, "logsEnabled: false")
    error_message = "datadog logsEnabled should be false"
  }

  assert {
    condition     = strcontains(output.rendered_values, "metricsEnabled: true")
    error_message = "datadog metricsEnabled should remain true when only logs are disabled"
  }
}

run "datadog_metrics_disabled" {
  command = plan

  variables {
    datadog_enabled         = true
    datadog_api_key         = "dd-test-key"
    datadog_metrics_enabled = false
  }

  assert {
    condition     = strcontains(output.rendered_values, "metricsEnabled: false")
    error_message = "datadog metricsEnabled should be false"
  }

  assert {
    condition     = strcontains(output.rendered_values, "logsEnabled: true")
    error_message = "datadog logsEnabled should remain true when only metrics are disabled"
  }
}

############################################
# Dynatrace logs/metrics split
############################################

run "dynatrace_logs_and_metrics_enabled_by_default" {
  command = plan

  variables {
    dynatrace_enabled        = true
    dynatrace_api_key        = "dt-test-key"
    dynatrace_environment_id = "dt-env-123"
  }

  assert {
    condition     = strcontains(output.rendered_values, "logsEnabled: true\n    metricsEnabled: true\n    apiKey: \"dt-test-key\"")
    error_message = "dynatrace logsEnabled and metricsEnabled should both default to true"
  }
}

run "dynatrace_logs_disabled" {
  command = plan

  variables {
    dynatrace_enabled      = true
    dynatrace_api_key      = "dt-test-key"
    dynatrace_environment_id = "dt-env-123"
    dynatrace_logs_enabled = false
  }

  assert {
    condition     = strcontains(output.rendered_values, "logsEnabled: false")
    error_message = "dynatrace logsEnabled should be false"
  }
}

run "dynatrace_metrics_disabled" {
  command = plan

  variables {
    dynatrace_enabled         = true
    dynatrace_api_key         = "dt-test-key"
    dynatrace_environment_id  = "dt-env-123"
    dynatrace_metrics_enabled = false
  }

  assert {
    condition     = strcontains(output.rendered_values, "metricsEnabled: false")
    error_message = "dynatrace metricsEnabled should be false"
  }
}

############################################
# New Relic logs/metrics split
############################################

run "newrelic_logs_and_metrics_enabled_by_default" {
  command = plan

  variables {
    newrelic_enabled     = true
    newrelic_license_key = "nr-test-key"
    newrelic_region      = "US"
  }

  assert {
    condition     = strcontains(output.rendered_values, "logsEnabled: true\n    metricsEnabled: true\n    licenseKey: \"nr-test-key\"")
    error_message = "newrelic logsEnabled and metricsEnabled should both default to true"
  }
}

run "newrelic_logs_disabled" {
  command = plan

  variables {
    newrelic_enabled      = true
    newrelic_license_key  = "nr-test-key"
    newrelic_region       = "US"
    newrelic_logs_enabled = false
  }

  assert {
    condition     = strcontains(output.rendered_values, "logsEnabled: false")
    error_message = "newrelic logsEnabled should be false"
  }
}

run "newrelic_metrics_disabled" {
  command = plan

  variables {
    newrelic_enabled         = true
    newrelic_license_key     = "nr-test-key"
    newrelic_region          = "US"
    newrelic_metrics_enabled = false
  }

  assert {
    condition     = strcontains(output.rendered_values, "metricsEnabled: false")
    error_message = "newrelic metricsEnabled should be false"
  }
}

############################################
# public gateway name + load balancer type
############################################

run "gateway_public_name_defaults_to_gateway_public" {
  command = plan

  assert {
    condition     = strcontains(output.rendered_values, "name: \"gateway-public\"")
    error_message = "public gateway name should default to gateway-public so existing installs keep their Gateway and HTTPRoute parentRefs"
  }
}

run "gateway_public_name_override" {
  command = plan

  variables {
    gateway_public_name = "internet-facing"
  }

  assert {
    condition     = strcontains(output.rendered_values, "name: \"internet-facing\"")
    error_message = "public gateway name should be overridable to match container-orchestration.gateway.public_name"
  }
}

run "gateway_public_load_balancer_type_defaults_to_external" {
  command = plan

  assert {
    condition     = strcontains(output.rendered_values, "loadBalancerType: \"external\"")
    error_message = "public gateway loadBalancerType should default to external"
  }
}

run "gateway_public_load_balancer_type_internal" {
  command = plan

  variables {
    gateway_public_load_balancer_type = "internal"
  }

  assert {
    condition     = strcontains(output.rendered_values, "loadBalancerType: \"internal\"\n")
    error_message = "public gateway loadBalancerType should be settable to internal for Cloudflare Tunnel / VPN setups"
  }
}
