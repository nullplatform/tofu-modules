mock_provider "nullplatform" {}

variables {
  nrn                     = "organization=myorg:account=myaccount"
  cluster_name            = "my-aks-cluster"
  resource_group          = "my-aks-resource-group"
  public_gateway_name     = "istio-ingress"
  traffic_manager_version = "1.8.0"
}

run "aks_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.aks_config.type == "aks-configuration"
    error_message = "Provider config type should be 'aks-configuration'"
  }

  assert {
    condition     = nullplatform_provider_config.aks_config.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "attributes_contain_cluster" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "my-aks-cluster")
    error_message = "Attributes should contain the cluster name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "my-aks-resource-group")
    error_message = "Attributes should contain the resource group"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "nullplatform")
    error_message = "Attributes should contain the default namespace"
  }
}

run "attributes_contain_gateway" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "istio-ingress")
    error_message = "Attributes should contain the public gateway name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "istio-ingress")
    error_message = "Attributes should contain the default gateway namespace"
  }
}

run "optional_fields_excluded_when_empty" {
  command = plan

  assert {
    condition     = !strcontains(nullplatform_provider_config.aks_config.attributes, "authentication_mode")
    error_message = "Attributes should not contain authentication_mode when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.aks_config.attributes, "private_name")
    error_message = "Attributes should not contain private_name when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.aks_config.attributes, "resource_management")
    error_message = "Attributes should not contain resource_management when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.aks_config.attributes, "security")
    error_message = "Attributes should not contain security when not set"
  }


  assert {
    condition     = !strcontains(nullplatform_provider_config.aks_config.attributes, "object_modifiers")
    error_message = "Attributes should not contain object_modifiers when not set"
  }
}

run "with_authentication_mode" {
  command = plan

  variables {
    authentication_mode = "localAccounts"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "authentication_mode")
    error_message = "Attributes should contain authentication_mode"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "localAccounts")
    error_message = "Attributes should contain localAccounts value"
  }
}

run "with_authentication_mode_aad" {
  command = plan

  variables {
    authentication_mode = "azureActiveDirectory"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "azureActiveDirectory")
    error_message = "Attributes should contain azureActiveDirectory value"
  }
}

run "with_private_gateway" {
  command = plan

  variables {
    private_gateway_name = "istio-ingress-private"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "istio-ingress-private")
    error_message = "Attributes should contain private gateway name"
  }
}

run "with_resource_management" {
  command = plan

  variables {
    memory_cpu_ratio              = "2048"
    memory_request_to_limit_ratio = "1"
    max_cores_multiplier          = "3"
    max_milicores                 = "4000"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "resource_management")
    error_message = "Attributes should contain resource_management"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "2048")
    error_message = "Attributes should contain memory_cpu_ratio value"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "4000")
    error_message = "Attributes should contain max_milicores value"
  }
}

run "with_partial_resource_management" {
  command = plan

  variables {
    memory_cpu_ratio = "4096"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "resource_management")
    error_message = "Attributes should contain resource_management with partial values"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "4096")
    error_message = "Attributes should contain memory_cpu_ratio value"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.aks_config.attributes, "max_milicores")
    error_message = "Attributes should not contain max_milicores when not set"
  }
}

run "with_security" {
  command = plan

  variables {
    image_pull_secrets   = ["image-pull-secret-nullplatform"]
    service_account_name = "my-service-account"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "security")
    error_message = "Attributes should contain security"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "image-pull-secret-nullplatform")
    error_message = "Attributes should contain image pull secret"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "my-service-account")
    error_message = "Attributes should contain service account name"
  }
}

run "with_multiple_image_pull_secrets" {
  command = plan

  variables {
    image_pull_secrets = ["secret-one", "secret-two", "secret-three"]
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "secret-one")
    error_message = "Attributes should contain first secret"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "secret-three")
    error_message = "Attributes should contain third secret"
  }
}

run "with_traffic_manager" {
  command = plan

  variables {
    traffic_manager_version = "1.8.0"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "traffic_manager")
    error_message = "Attributes should contain traffic_manager"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "1.8.0")
    error_message = "Attributes should contain traffic manager version"
  }
}

run "with_object_modifiers" {
  command = plan

  variables {
    object_modifiers = [
      {
        selector = ".spec.template.spec.containers[0].resources.limits.memory"
        action   = "update"
        type     = "deployment"
        value    = "512Mi"
      }
    ]
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "object_modifiers")
    error_message = "Attributes should contain object_modifiers"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "deployment")
    error_message = "Attributes should contain modifier type"
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
    condition     = nullplatform_provider_config.aks_config.dimensions["Environment"] == "production"
    error_message = "Dimensions should contain Environment=production"
  }
}

run "with_custom_namespace" {
  command = plan

  variables {
    namespace_application_default = "custom-namespace"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "custom-namespace")
    error_message = "Attributes should contain custom namespace"
  }
}

run "with_all_options" {
  command = plan

  variables {
    authentication_mode           = "localandAAD"
    private_gateway_name          = "istio-ingress-private"
    memory_cpu_ratio              = "4096"
    memory_request_to_limit_ratio = "2"
    max_cores_multiplier          = "4"
    max_milicores                 = "8000"
    image_pull_secrets            = ["secret-one", "secret-two"]
    service_account_name          = "full-sa"
    traffic_manager_version       = "beta"
    object_modifiers = [
      {
        selector = ".metadata.labels.app"
        action   = "add"
        type     = "service"
        value    = "my-app"
      }
    ]
    dimensions = {
      "Environment" = "staging"
    }
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "localandAAD")
    error_message = "Attributes should contain authentication mode"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "istio-ingress-private")
    error_message = "Attributes should contain private gateway"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "resource_management")
    error_message = "Attributes should contain resource_management"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "security")
    error_message = "Attributes should contain security"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "traffic_manager")
    error_message = "Attributes should contain traffic_manager"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aks_config.attributes, "object_modifiers")
    error_message = "Attributes should contain object_modifiers"
  }

  assert {
    condition     = nullplatform_provider_config.aks_config.dimensions["Environment"] == "staging"
    error_message = "Dimensions should contain Environment=staging"
  }
}

run "naming_absent_by_default" {
  command = plan

  assert {
    condition     = !contains(keys(jsondecode(nullplatform_provider_config.aks_config.attributes)), "naming")
    error_message = "Attributes should not contain naming when not set"
  }
}

run "naming_qualified_strategy" {
  command = plan

  variables {
    naming_strategy = "qualified"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.aks_config.attributes).naming == { strategy = "qualified" }
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
    condition = jsondecode(nullplatform_provider_config.aks_config.attributes).naming == {
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
    condition     = length(jsondecode(nullplatform_provider_config.aks_config.attributes).naming.deployment_pattern) == 200
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

run "with_namespace_parity" {
  command = plan

  variables {
    use_nullplatform_namespace    = true
    naming_namespace_pattern      = "{.account.slug}-{.namespace.slug}"
    namespace_bootstrap_resources = ["networkpolicy/default-deny", "limitrange/defaults"]
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.aks_config.attributes).cluster.use_nullplatform_namespace == true
    error_message = "cluster.use_nullplatform_namespace should be true when enabled"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.aks_config.attributes).naming.namespace_pattern == "{.account.slug}-{.namespace.slug}"
    error_message = "naming.namespace_pattern should match input"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.aks_config.attributes).cluster.namespace_bootstrap_resources == ["networkpolicy/default-deny", "limitrange/defaults"]
    error_message = "cluster.namespace_bootstrap_resources should match input"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.aks_config.attributes).cluster.namespace == "nullplatform"
    error_message = "cluster.namespace should stay as the static namespace"
  }
}

run "without_namespace_parity" {
  command = plan

  assert {
    condition = length(setintersection(
      keys(jsondecode(nullplatform_provider_config.aks_config.attributes).cluster),
      ["use_nullplatform_namespace", "namespace_bootstrap_resources"]
    )) == 0
    error_message = "Namespace parity attributes should not be written by default"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.aks_config.attributes, "namespace_pattern")
    error_message = "naming.namespace_pattern should not be written by default"
  }
}

run "rejects_namespace_pattern_without_placeholder" {
  command = plan

  variables {
    naming_namespace_pattern = "payments"
  }

  expect_failures = [var.naming_namespace_pattern]
}

run "rejects_secrets_in_namespace_bootstrap_resources" {
  command = plan

  variables {
    namespace_bootstrap_resources = ["secret/agent-credentials"]
  }

  expect_failures = [var.namespace_bootstrap_resources]
}

run "additional_gateways_absent_by_default" {
  command = plan

  assert {
    condition     = !contains(keys(try(jsondecode(nullplatform_provider_config.aks_config.attributes).gateway, {})), "additional_public_gateways")
    error_message = "gateway should not carry additional_public_gateways when not set"
  }

  assert {
    condition     = !contains(keys(try(jsondecode(nullplatform_provider_config.aks_config.attributes).gateway, {})), "additional_private_gateways")
    error_message = "gateway should not carry additional_private_gateways when not set"
  }
}

run "additional_public_gateways_omit_unset_namespace" {
  command = plan

  variables {
    additional_public_gateways = [
      { name = "edge", namespace = "istio-edge" },
      { name = "public-gateway-eu" },
    ]
  }

  assert {
    condition = jsondecode(nullplatform_provider_config.aks_config.attributes).gateway.additional_public_gateways == [
      { name = "edge", namespace = "istio-edge" },
      { name = "public-gateway-eu" },
    ]
    error_message = "additional_public_gateways should keep each entry and drop the namespace that was not set"
  }

  assert {
    condition     = !contains(keys(jsondecode(nullplatform_provider_config.aks_config.attributes).gateway), "additional_private_gateways")
    error_message = "additional_private_gateways should stay out when only the public list is set"
  }
}

run "additional_private_gateways" {
  command = plan

  variables {
    additional_private_gateways = [
      { name = "internal.edge", namespace = "istio-internal" },
    ]
  }

  assert {
    condition = jsondecode(nullplatform_provider_config.aks_config.attributes).gateway.additional_private_gateways == [
      { name = "internal.edge", namespace = "istio-internal" },
    ]
    error_message = "additional_private_gateways should reach the provider config"
  }
}

run "additional_gateways_reject_invalid_name" {
  command = plan

  variables {
    additional_public_gateways = [{ name = "Edge_Gateway" }]
  }

  expect_failures = [var.additional_public_gateways]
}

run "additional_gateways_reject_invalid_namespace" {
  command = plan

  variables {
    additional_private_gateways = [{ name = "edge", namespace = "istio.edge" }]
  }

  expect_failures = [var.additional_private_gateways]
}

run "main_gateway_names_accept_dns_subdomains" {
  command = plan

  variables {
    gateway_namespace    = "istio-ingress"
    public_gateway_name  = "public.edge"
    private_gateway_name = "0-internal"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.aks_config.attributes).gateway.public_name == "public.edge"
    error_message = "a dotted public gateway name should be accepted, as it is for additional gateways"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.aks_config.attributes).gateway.private_name == "0-internal"
    error_message = "a private gateway name starting with a digit should be accepted"
  }
}

run "main_gateway_rejects_uppercase_public_name" {
  command = plan

  variables {
    public_gateway_name = "Public-Gateway"
  }

  expect_failures = [var.public_gateway_name]
}

run "main_gateway_rejects_invalid_private_name" {
  command = plan

  variables {
    private_gateway_name = "private_gateway"
  }

  expect_failures = [var.private_gateway_name]
}

run "main_gateway_rejects_dotted_namespace" {
  command = plan

  variables {
    gateway_namespace = "istio.ingress"
  }

  expect_failures = [var.gateway_namespace]
}
