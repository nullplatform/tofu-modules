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
