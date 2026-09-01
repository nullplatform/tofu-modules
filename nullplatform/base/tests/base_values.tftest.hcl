mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  np_api_key                     = "test-api-key"
  k8s_provider                   = "eks"
  nullplatform_base_helm_version = "2.44.0"
  logging_controller_image_tag   = "1.6.0"
  control_plane_agent_image_tag  = "0.9.2"
}

############################################
# Gateway API CRD ref
############################################

run "gateway_api_crd_ref_defaults_to_istio_1_27_ref" {
  command = plan

  assert {
    condition     = strcontains(output.rendered_values, "gatewayApiCrdRef: \"v1.3.0\"")
    error_message = "gatewayApiCrdRef should default to v1.3.0, matching Istio 1.27"
  }
}

run "gateway_api_crd_ref_override" {
  command = plan

  variables {
    gateway_api_crd_ref = "v1.6.0"
  }

  assert {
    condition     = strcontains(output.rendered_values, "gatewayApiCrdRef: \"v1.6.0\"")
    error_message = "gatewayApiCrdRef should reflect the overridden ref"
  }
}

run "install_gateway_v2_crd_defaults_to_true" {
  command = plan

  assert {
    condition     = strcontains(output.rendered_values, "installGatewayV2Crd: true")
    error_message = "install_gateway_v2_crd should default to true so CRDs actually reconcile to gateway_api_crd_ref"
  }
}

run "install_gateway_v2_crd_override" {
  command = plan

  variables {
    install_gateway_v2_crd = false
  }

  assert {
    condition     = strcontains(output.rendered_values, "installGatewayV2Crd: false")
    error_message = "install_gateway_v2_crd should still be overridable to false"
  }
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
    dynatrace_enabled        = true
    dynatrace_api_key        = "dt-test-key"
    dynatrace_environment_id = "dt-env-123"
    dynatrace_logs_enabled   = false
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

run "gateway_public_azure_load_balancer_subnet" {
  command = plan

  variables {
    gateway_public_azure_load_balancer_subnet = "snet-aks-lab"
  }

  assert {
    condition     = strcontains(output.rendered_values, "subnet: \"snet-aks-lab\"")
    error_message = "public gateway azure subnet should be wired into the rendered public.azure block"
  }
}

run "internal_azure_load_balancer_subnet_defaults_to_empty" {
  command = plan

  # The old default was the literal "load_balancer", which is the key a subnet
  # usually has in a subnets_definition map rather than its resource name. That
  # annotated the internal gateway with a subnet that does not exist, and Azure
  # answers a missing scope with 403 AuthorizationFailed, which reads like an
  # RBAC problem instead of a wrong name. Empty lets Azure pick the subnet.
  assert {
    condition     = strcontains(output.rendered_values, "azure_load_balancer_subnet: \"\"")
    error_message = "internal gateway azure subnet should default to empty so Azure selects the subnet"
  }
}

run "internal_azure_load_balancer_subnet" {
  command = plan

  variables {
    internal_azure_load_balancer_subnet = "subnet-4"
  }

  assert {
    condition     = strcontains(output.rendered_values, "azure_load_balancer_subnet: \"subnet-4\"")
    error_message = "internal gateway azure subnet should be wired into the rendered internal block"
  }
}

############################################
# Container image repository/tag overrides
############################################

run "logs_controller_image_defaults_to_pinned_tag" {
  command = plan

  assert {
    condition     = strcontains(output.rendered_values, "image: \"public.ecr.aws/nullplatform/k8s-logs-controller:1.6.0\"")
    error_message = "logs controller image should default to the pinned repository:tag"
  }
}

run "logs_controller_image_tag_overridden" {
  command = plan

  variables {
    logging_controller_image_tag = "1.7.0"
  }

  assert {
    condition     = strcontains(output.rendered_values, "image: \"public.ecr.aws/nullplatform/k8s-logs-controller:1.7.0\"")
    error_message = "logs controller tag should be overridable without touching the repository"
  }
}

run "logs_controller_image_repository_overridden" {
  command = plan

  # Redirect to a private mirror/ECR pull-through cache without needing to also
  # know or restate the tag.
  variables {
    logging_controller_image_repository = "123456789012.dkr.ecr.us-east-1.amazonaws.com/k8s-logs-controller"
  }

  assert {
    condition     = strcontains(output.rendered_values, "image: \"123456789012.dkr.ecr.us-east-1.amazonaws.com/k8s-logs-controller:1.6.0\"")
    error_message = "logs controller repository should be overridable without touching the tag"
  }
}

run "control_plane_agent_image_defaults_to_pinned_tag" {
  command = plan

  assert {
    condition     = strcontains(output.rendered_values, "image: \"public.ecr.aws/nullplatform/controlplane-agent:0.9.2\"")
    error_message = "control plane agent image should default to the pinned repository:tag"
  }
}

run "control_plane_agent_image_tag_overridden" {
  command = plan

  variables {
    control_plane_agent_image_tag = "0.9.3"
  }

  assert {
    condition     = strcontains(output.rendered_values, "image: \"public.ecr.aws/nullplatform/controlplane-agent:0.9.3\"")
    error_message = "control plane agent tag should be overridable without touching the repository"
  }
}
