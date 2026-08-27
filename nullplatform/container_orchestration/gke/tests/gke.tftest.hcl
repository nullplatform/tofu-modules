mock_provider "nullplatform" {}

variables {
  nrn                     = "organization=myorg:account=myaccount"
  cluster_name            = "my-gke-cluster"
  location                = "us-central1-a"
  public_gateway_name     = "public-gateway"
  traffic_manager_version = "1.8.0"
}

run "gke_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.gke_config.type == "gke-configuration"
    error_message = "Provider config type should be 'gke-configuration'"
  }

  assert {
    condition     = nullplatform_provider_config.gke_config.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "attributes_contain_cluster" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "my-gke-cluster")
    error_message = "Attributes should contain the cluster name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "us-central1-a")
    error_message = "Attributes should contain the location"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "nullplatform")
    error_message = "Attributes should contain the default namespace"
  }
}

run "attributes_contain_gateway" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "public-gateway")
    error_message = "Attributes should contain the public gateway name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "istio-ingress-system")
    error_message = "Attributes should contain the default gateway namespace"
  }
}

run "optional_fields_excluded_when_empty" {
  command = plan

  assert {
    condition     = !strcontains(nullplatform_provider_config.gke_config.attributes, "private_name")
    error_message = "Attributes should not contain private_name when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.gke_config.attributes, "resource_management")
    error_message = "Attributes should not contain resource_management when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.gke_config.attributes, "security")
    error_message = "Attributes should not contain security when not set"
  }


  assert {
    condition     = !strcontains(nullplatform_provider_config.gke_config.attributes, "object_modifiers")
    error_message = "Attributes should not contain object_modifiers when not set"
  }
}

run "with_private_gateway" {
  command = plan

  variables {
    private_gateway_name = "private-gateway"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "private-gateway")
    error_message = "Attributes should contain the private gateway name"
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
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "resource_management")
    error_message = "Attributes should contain resource_management"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "2048")
    error_message = "Attributes should contain memory_cpu_ratio value"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "4000")
    error_message = "Attributes should contain max_milicores value"
  }
}

run "with_security" {
  command = plan

  variables {
    image_pull_secrets   = ["image-pull-secret-nullplatform"]
    service_account_name = "my-service-account"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "security")
    error_message = "Attributes should contain security"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "image-pull-secret-nullplatform")
    error_message = "Attributes should contain image pull secret"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "my-service-account")
    error_message = "Attributes should contain service account name"
  }
}

run "with_traffic_manager" {
  command = plan

  variables {
    traffic_manager_version = "1.8.0"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "traffic_manager")
    error_message = "Attributes should contain traffic_manager"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "1.8.0")
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
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "object_modifiers")
    error_message = "Attributes should contain object_modifiers"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "deployment")
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
    condition     = nullplatform_provider_config.gke_config.dimensions["Environment"] == "production"
    error_message = "Dimensions should contain Environment=production"
  }
}

run "with_custom_namespace" {
  command = plan

  variables {
    namespace_application_default = "custom-namespace"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "custom-namespace")
    error_message = "Attributes should contain custom namespace"
  }
}

run "with_all_options" {
  command = plan

  variables {
    private_gateway_name          = "private-gateway"
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
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "private-gateway")
    error_message = "Attributes should contain private gateway"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "resource_management")
    error_message = "Attributes should contain resource_management"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "security")
    error_message = "Attributes should contain security"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "traffic_manager")
    error_message = "Attributes should contain traffic_manager"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gke_config.attributes, "object_modifiers")
    error_message = "Attributes should contain object_modifiers"
  }

  assert {
    condition     = nullplatform_provider_config.gke_config.dimensions["Environment"] == "staging"
    error_message = "Dimensions should contain Environment=staging"
  }
}
