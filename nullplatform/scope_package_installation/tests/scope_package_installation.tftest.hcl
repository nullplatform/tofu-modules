mock_provider "nullplatform" {}
mock_provider "external" {}

# Templates come from the fixture checkout. The gomplate render of the scope
# type is mocked because the CI runner has no gomplate; scope_definition's
# tests render the same template with the real one. The scope configuration is
# not gomplate and is read from the fixture.
override_data {
  target = data.external.scope_type
  values = {
    result = {
      json = "{\"name\":\"Example Functions\",\"description\":\"Example functions\",\"provider_type\":\"service\"}"
    }
  }
}

override_data {
  target = module.installation.data.nullplatform_package.this
  values = {
    id          = "dummy-package-id"
    revision_id = "dummy-revision-id"
    components = [
      { name = "spec", resource_type = "service_specification", resource_id = "dummy-spec-id", resource_revision_id = "dummy-spec-snapshot", parent_id = null },
      { name = "worker-image", resource_type = "artifact", resource_id = "dummy-artifact-id", resource_revision_id = "dummy-artifact-revision", parent_id = null },
    ]
  }
}

override_data {
  target = module.installation.data.nullplatform_service_specification.this
  values = {
    slug = "example-functions"
  }
}

# The channel has its own tests (scope_definition_agent_association, local
# template). Mocked here because the test framework's mock provider cannot plan
# a resource whose dynamic block count is still unknown, which is the case for
# the channel on a first install: its template renders once the specification
# is readable, after the installation exists.
override_module {
  target = module.agent_channel
  outputs = {
    notification_channel_id = "dummy-channel-id"
  }
}

variables {
  nrn                  = "organization=1:account=2"
  package_slug         = "dummy-scope"
  package_version      = "1.2.3"
  local_specs_path     = "./tests/fixtures/scope"
  service_path         = "scope"
  agent_tags_selectors = { cluster = "test" }
}

run "the_scope_type_points_at_the_package_specification" {
  command = plan

  assert {
    condition     = nullplatform_scope_type.this.provider_id == "dummy-spec-id"
    error_message = "The scope type must point at the specification of the package, which the organization does not own"
  }

  assert {
    condition     = nullplatform_scope_type.this.name == "Example Functions" && nullplatform_scope_type.this.provider_type == "service"
    error_message = "The scope type must take its name and provider type from the rendered template"
  }

  assert {
    condition     = nullplatform_scope_type.this.nrn == "organization=1:account=2"
    error_message = "The scope type belongs to the installing organization"
  }
}

# Plan only, in every run: the NRN settings are written by a local-exec `np nrn
# patch`, which an override does not skip, so an apply would call the API. On
# a first install the specification slug is unknown at plan (the specification
# is readable once the installation exists); the providers are known.
run "nrn_settings_record_the_providers" {
  command = plan

  variables {
    external_metrics_provider = "dummy-metrics"
    external_logging_provider = "dummy-logs"
  }

  assert {
    condition     = terraform_data.nrn_settings.triggers_replace.metrics_provider == "dummy-metrics" && terraform_data.nrn_settings.triggers_replace.logging_provider == "dummy-logs"
    error_message = "The NRN settings must record the metrics and logs providers"
  }

  assert {
    condition     = terraform_data.nrn_settings.triggers_replace.nrn == "organization=1:account=2"
    error_message = "The NRN settings are written at nrn"
  }
}

run "scope_configuration_is_opt_in" {
  command = plan

  assert {
    condition     = length(nullplatform_provider_specification.scope_configuration) == 0
    error_message = "Without create_scope_configuration no provider specification may be created"
  }
}

run "scope_configuration_is_created_from_the_template" {
  command = plan

  variables {
    create_scope_configuration = true
  }

  assert {
    condition     = nullplatform_provider_specification.scope_configuration[0].name == "Example Functions"
    error_message = "The provider specification must take the template's name"
  }

  assert {
    condition     = nullplatform_provider_specification.scope_configuration[0].visible_to == tolist(["organization=1:account=2"])
    error_message = "The provider specification must be visible only at nrn"
  }
}

run "scope_configuration_name_can_be_overridden" {
  command = plan

  variables {
    create_scope_configuration = true
    scope_configuration_name   = "Example Functions (account 2)"
  }

  assert {
    condition     = nullplatform_provider_specification.scope_configuration[0].name == "Example Functions (account 2)"
    error_message = "scope_configuration_name must override the template's name"
  }
}

run "scope_type_name_can_be_overridden" {
  command = plan

  variables {
    scope_type_name = "Example Functions (global)"
  }

  assert {
    condition     = nullplatform_scope_type.this.name == "Example Functions (global)"
    error_message = "scope_type_name must override the template's name"
  }
}

run "a_package_with_two_specifications_is_refused" {
  command = plan

  override_data {
    target = module.installation.data.nullplatform_package.this
    values = {
      id          = "dummy-package-id"
      revision_id = "dummy-revision-id"
      components = [
        { name = "spec-a", resource_type = "service_specification", resource_id = "dummy-spec-a", resource_revision_id = "dummy-a", parent_id = null },
        { name = "spec-b", resource_type = "service_specification", resource_id = "dummy-spec-b", resource_revision_id = "dummy-b", parent_id = null },
      ]
    }
  }

  expect_failures = [nullplatform_scope_type.this]
}

run "the_channel_can_be_left_to_the_bindings_layer" {
  command = plan

  variables {
    create_agent_channel = false
    agent_tags_selectors = null
    service_path         = null
  }

  assert {
    condition     = output.notification_channel_id == null
    error_message = "Without create_agent_channel no channel may be created: the organization creates it in its bindings layer"
  }

  assert {
    condition     = nullplatform_scope_type.this.provider_id == "dummy-spec-id"
    error_message = "The scope type is created whether or not the module creates the channel"
  }
}

run "a_channel_without_tags_is_refused" {
  command = plan

  variables {
    agent_tags_selectors = {}
  }

  expect_failures = [var.agent_tags_selectors]
}

run "a_channel_without_service_path_is_refused" {
  command = plan

  variables {
    service_path = null
  }

  expect_failures = [var.service_path]
}

# The installation is overridden whole: the specification slug comes from a
# read that waits for the installation, so it is unknown at plan otherwise.
run "outputs_carry_the_names_scope_definition_uses" {
  command = plan

  override_module {
    target = module.installation
    outputs = {
      installation_id               = "dummy-installation-id"
      package_id                    = "dummy-package-id"
      installed_version             = "1.2.3"
      missing_optional_requirements = []
      service_specification_ids     = ["dummy-spec-id"]
      service_specification_id      = "dummy-spec-id"
      service_specification_slug    = "example-functions"
    }
  }

  assert {
    condition     = output.service_slug == "example-functions" && output.service_specification_slug == "example-functions"
    error_message = "service_slug must be the specification slug, as scope_definition reports it"
  }

  assert {
    condition     = output.package_id == "dummy-package-id"
    error_message = "package_id must be the installed package"
  }

  assert {
    condition     = output.package_default_version == "1.2.3"
    error_message = "package_default_version must be the installed version"
  }
}
