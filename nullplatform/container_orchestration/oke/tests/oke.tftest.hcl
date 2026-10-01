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
    }
    error_message = "Attributes should only carry cluster and gateway with their defaults"
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

run "naming_absent_by_default" {
  command = plan

  assert {
    condition     = !contains(keys(jsondecode(nullplatform_provider_config.oke_config.attributes)), "naming")
    error_message = "Attributes should not contain naming when not set"
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
