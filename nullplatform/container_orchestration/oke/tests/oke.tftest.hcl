mock_provider "nullplatform" {}

variables {
  nrn          = "organization=myorg:account=myaccount"
  cluster_name = "my-oke-cluster"
  region       = "us-ashburn-1"
}

run "oke_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.oke_config.type == "oke"
    error_message = "Provider config type should be 'oke'"
  }

  assert {
    condition     = nullplatform_provider_config.oke_config.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "attributes_with_defaults" {
  command = plan

  assert {
    condition = jsondecode(nullplatform_provider_config.oke_config.attributes) == {
      cluster = {
        id        = "my-oke-cluster"
        namespace = "nullplatform"
        location  = "us-ashburn-1"
      }
      gateway = {
        namespace    = "gateways"
        public_name  = "public-gateway"
        private_name = "private-gateway"
      }
      naming = {
        strategy = "qualified"
      }
    }
    error_message = "Attributes should only carry cluster, gateway and naming with their defaults"
  }
}

run "namespace_accepts_a_pattern" {
  command = plan

  variables {
    namespace_application_default = "{.namespace.slug}"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.oke_config.attributes).cluster.namespace == "{.namespace.slug}"
    error_message = "cluster.namespace should carry the pattern as is, for the scope to render it"
  }
}

run "with_dimensions" {
  command = plan

  variables {
    dimensions = {
      "Environment" = "production"
    }
  }

  assert {
    condition     = nullplatform_provider_config.oke_config.dimensions["Environment"] == "production"
    error_message = "Dimensions should contain Environment=production"
  }
}

run "naming_qualified_by_default" {
  command = plan

  assert {
    condition     = jsondecode(nullplatform_provider_config.oke_config.attributes).naming == { strategy = "qualified" }
    error_message = "Naming strategy should default to qualified"
  }
}

run "naming_qualified_strategy" {
  command = plan

  variables {
    naming_strategy = "qualified"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.oke_config.attributes).naming == { strategy = "qualified" }
    error_message = "naming should only carry the strategy"
  }
}

run "naming_custom_patterns" {
  command = plan

  variables {
    naming_strategy           = "custom"
    naming_deployment_pattern = "{.namespace.slug}-{.application.slug}-{.deployment.id}"
    naming_scope_pattern      = "{.application.slug}-{.scope.slug}-{.scope.id}"
  }

  assert {
    condition = jsondecode(nullplatform_provider_config.oke_config.attributes).naming == {
      strategy           = "custom"
      deployment_pattern = "{.namespace.slug}-{.application.slug}-{.deployment.id}"
      scope_pattern      = "{.application.slug}-{.scope.slug}-{.scope.id}"
    }
    error_message = "naming should carry strategy and both patterns"
  }
}

run "naming_rejects_unknown_strategy" {
  command = plan

  variables {
    naming_strategy = "slugs"
  }

  expect_failures = [var.naming_strategy]
}

run "naming_rejects_invalid_deployment_pattern" {
  command = plan

  variables {
    naming_strategy           = "custom"
    naming_deployment_pattern = "{.application.slug}/{.deployment.id}"
  }

  expect_failures = [var.naming_deployment_pattern]
}

run "naming_rejects_invalid_scope_pattern" {
  command = plan

  variables {
    naming_strategy      = "custom"
    naming_scope_pattern = "{.scope.slug} {.scope.id}"
  }

  expect_failures = [var.naming_scope_pattern]
}

run "naming_accepts_deployment_pattern_at_length_limit" {
  command = plan

  variables {
    naming_strategy           = "custom"
    naming_deployment_pattern = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }

  assert {
    condition     = length(jsondecode(nullplatform_provider_config.oke_config.attributes).naming.deployment_pattern) == 200
    error_message = "a 200-character deployment pattern should be accepted"
  }
}

run "naming_rejects_too_long_deployment_pattern" {
  command = plan

  variables {
    naming_strategy           = "custom"
    naming_deployment_pattern = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }

  expect_failures = [var.naming_deployment_pattern]
}

run "naming_rejects_too_long_scope_pattern" {
  command = plan

  variables {
    naming_strategy      = "custom"
    naming_scope_pattern = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }

  expect_failures = [var.naming_scope_pattern]
}

run "service_to_service_absent_by_default" {
  command = plan

  assert {
    condition     = !strcontains(nullplatform_provider_config.oke_config.attributes, "service_to_service")
    error_message = "gateway.service_to_service should not be sent when no service_to_service_* variable is set"
  }
}

run "service_to_service_enabled_sends_spec_defaults" {
  command = plan

  variables {
    service_to_service_enabled = true
  }

  assert {
    condition = jsondecode(nullplatform_provider_config.oke_config.attributes).gateway.service_to_service == {
      enabled = true
      mode    = "shared"
    }
    error_message = "gateway.service_to_service should carry enabled and the spec's default mode, as the API stores it"
  }
}

run "service_to_service_all_settings" {
  command = plan

  variables {
    service_to_service_enabled         = true
    service_to_service_mode            = "dedicated"
    service_to_service_gateway_name    = "gateway-in-cluster"
    service_to_service_listener_prefix = "in-cluster-"
    service_to_service_cluster_domain  = "cluster.local"
    service_to_service_name_pattern    = "{.application.slug}-{.scope.slug}"
  }

  assert {
    condition = jsondecode(nullplatform_provider_config.oke_config.attributes).gateway.service_to_service == {
      enabled         = true
      mode            = "dedicated"
      gateway_name    = "gateway-in-cluster"
      listener_prefix = "in-cluster-"
      cluster_domain  = "cluster.local"
      name_pattern    = "{.application.slug}-{.scope.slug}"
    }
    error_message = "gateway.service_to_service should carry every set field, with enabled as a boolean"
  }
}

run "service_to_service_disabled_is_sent" {
  command = plan

  variables {
    service_to_service_enabled = false
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.oke_config.attributes).gateway.service_to_service.enabled == false
    error_message = "an explicit false should be sent, to turn the feature off over an inherited provider"
  }
}

run "service_to_service_rejects_unknown_mode" {
  command = plan

  variables {
    service_to_service_mode = "mesh"
  }

  expect_failures = [var.service_to_service_mode]
}

run "service_to_service_rejects_invalid_gateway_name" {
  command = plan

  variables {
    service_to_service_gateway_name = "Gateway_In_Cluster"
  }

  expect_failures = [var.service_to_service_gateway_name]
}

run "service_to_service_rejects_invalid_listener_prefix" {
  command = plan

  variables {
    service_to_service_listener_prefix = "-in-cluster"
  }

  expect_failures = [var.service_to_service_listener_prefix]
}

run "service_to_service_rejects_invalid_name_pattern" {
  command = plan

  variables {
    service_to_service_name_pattern = "{.application.slug} {.scope.slug}"
  }

  expect_failures = [var.service_to_service_name_pattern]
}
