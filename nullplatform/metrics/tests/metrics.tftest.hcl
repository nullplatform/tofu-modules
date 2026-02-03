mock_provider "nullplatform" {}

variables {
  nrn        = "organization=myorg:account=myaccount"
  np_api_key = "test-api-key"
}

run "prometheus_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.prometheus.type == "prometheus"
    error_message = "Provider config type should be 'prometheus'"
  }

  assert {
    condition     = nullplatform_provider_config.prometheus.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "default_prometheus_url" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.prometheus.attributes, "prometheus-server.prometheus.svc.cluster.local")
    error_message = "Default URL should use in-cluster prometheus service"
  }
}

run "custom_prometheus_url" {
  command = plan

  variables {
    prometheus_url = "https://prometheus.example.com"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.prometheus.attributes, "prometheus.example.com")
    error_message = "Should use custom prometheus URL"
  }
}

run "custom_namespace" {
  command = plan

  variables {
    prometheus_namespace = "monitoring"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.prometheus.attributes, "prometheus-server.monitoring.svc.cluster.local")
    error_message = "Should use custom namespace in default URL"
  }
}
