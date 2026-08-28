mock_provider "nullplatform" {}

variables {
  nrn                     = "organization=myorg:account=myaccount"
  cluster_name            = "my-eks-cluster"
  traffic_manager_version = "1.8.0"
}

run "eks_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.eks_config.type == "eks-configuration"
    error_message = "Provider config type should be 'eks-configuration'"
  }

  assert {
    condition     = nullplatform_provider_config.eks_config.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "attributes_contain_cluster" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "my-eks-cluster")
    error_message = "Attributes should contain the cluster name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "nullplatform")
    error_message = "Attributes should contain the default namespace"
  }
}

run "optional_fields_excluded_when_empty" {
  command = plan

  assert {
    condition     = !strcontains(nullplatform_provider_config.eks_config.attributes, "balancer")
    error_message = "Attributes should not contain balancer when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.eks_config.attributes, "network")
    error_message = "Attributes should not contain network when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.eks_config.attributes, "resource_management")
    error_message = "Attributes should not contain resource_management when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.eks_config.attributes, "security")
    error_message = "Attributes should not contain security when not set"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.eks_config.attributes, "object_modifiers")
    error_message = "Attributes should not contain object_modifiers when not set"
  }
}

run "with_use_nullplatform_namespace" {
  command = plan

  variables {
    use_nullplatform_namespace = true
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "use_nullplatform_namespace")
    error_message = "Attributes should contain use_nullplatform_namespace when enabled"
  }
}

run "without_use_nullplatform_namespace" {
  command = plan

  variables {
    use_nullplatform_namespace = false
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.eks_config.attributes, "use_nullplatform_namespace")
    error_message = "Attributes should not contain use_nullplatform_namespace when disabled"
  }
}

run "with_balancer" {
  command = plan

  variables {
    public_balancer_name  = "my-public-balancer"
    private_balancer_name = "my-private-balancer"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "balancer")
    error_message = "Attributes should contain balancer"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "my-public-balancer")
    error_message = "Attributes should contain public balancer name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "my-private-balancer")
    error_message = "Attributes should contain private balancer name"
  }
}

run "with_network" {
  command = plan

  variables {
    balancer_group_suffix = "my-suffix"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "network")
    error_message = "Attributes should contain network"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "my-suffix")
    error_message = "Attributes should contain balancer group suffix"
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
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "resource_management")
    error_message = "Attributes should contain resource_management"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "2048")
    error_message = "Attributes should contain memory_cpu_ratio value"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "4000")
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
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "security")
    error_message = "Attributes should contain security"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "image-pull-secret-nullplatform")
    error_message = "Attributes should contain image pull secret"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "my-service-account")
    error_message = "Attributes should contain service account name"
  }
}

run "with_traffic_manager" {
  command = plan

  variables {
    traffic_manager_version = "1.8.0"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "traffic_manager")
    error_message = "Attributes should contain traffic_manager"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "1.8.0")
    error_message = "Attributes should contain traffic manager version"
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.eks_config.attributes, "\"port\"")
    error_message = "Attributes should not contain traffic manager port when not set"
  }
}

run "with_traffic_manager_port" {
  command = plan

  variables {
    traffic_manager_port = 10080
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "\"port\":10080")
    error_message = "Attributes should contain the traffic manager port"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "\"version\":\"1.8.0\"")
    error_message = "Setting the port must not drop the traffic manager version"
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
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "object_modifiers")
    error_message = "Attributes should contain object_modifiers"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "deployment")
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
    condition     = nullplatform_provider_config.eks_config.dimensions["Environment"] == "production"
    error_message = "Dimensions should contain Environment=production"
  }
}

run "with_custom_namespace" {
  command = plan

  variables {
    namespace_application_default = "custom-namespace"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "custom-namespace")
    error_message = "Attributes should contain custom namespace"
  }
}

run "with_all_options" {
  command = plan

  variables {
    use_nullplatform_namespace    = true
    public_balancer_name          = "my-public-balancer"
    private_balancer_name         = "my-private-balancer"
    balancer_group_suffix         = "my-suffix"
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
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "use_nullplatform_namespace")
    error_message = "Attributes should contain use_nullplatform_namespace"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "balancer")
    error_message = "Attributes should contain balancer"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "network")
    error_message = "Attributes should contain network"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "resource_management")
    error_message = "Attributes should contain resource_management"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "security")
    error_message = "Attributes should contain security"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "traffic_manager")
    error_message = "Attributes should contain traffic_manager"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "object_modifiers")
    error_message = "Attributes should contain object_modifiers"
  }

  assert {
    condition     = nullplatform_provider_config.eks_config.dimensions["Environment"] == "staging"
    error_message = "Dimensions should contain Environment=staging"
  }
}

################################################################################
# Version pinning
################################################################################

# The default used to be "latest", so an apply with no code change could move the deployed
# version. There is no default now -- the caller has to name one -- and this is the guard
# that a moving reference cannot reach the provider config by any route.
run "no_moving_reference_reaches_the_provider_config" {
  command = plan

  assert {
    condition     = !strcontains(nullplatform_provider_config.eks_config.attributes, "latest")
    error_message = "no attribute may reference a moving tag"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.eks_config.attributes, "\"version\":\"1.8.0\"")
    error_message = "the version the caller supplied must reach the provider config"
  }
}
