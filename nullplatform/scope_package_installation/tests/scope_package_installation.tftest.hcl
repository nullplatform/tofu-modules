mock_provider "nullplatform" {}
mock_provider "http" {}

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

# What the scope repository serves at <repository>/<ref>/<service_path>/specs/
# scope-configuration.json.tpl. The same file as the fixture checkout holds, so
# the two template sources can be asserted against the same values.
override_data {
  target = data.http.scope_configuration_template
  values = {
    status_code   = 200
    response_body = <<-EOT
      {
        "name": "Example Functions",
        "description": "Scope-wide configuration for example scopes",
        "category": "scope-configurations",
        "icon": "np:example",
        "visible_to": ["{{ env.Getenv "NRN" }}"],
        "allow_dimensions": true,
        "schema": { "type": "object", "properties": { "state_bucket": { "type": "string" } } }
      }
    EOT
  }
}

# The channel has its own tests (scope_definition_agent_association, local and
# HTTP template). Mocked here because the test framework's mock provider cannot
# plan a resource whose dynamic block count is still unknown, which is the case
# for the channel on a first install: its template renders once the
# specification is readable, after the installation exists.
override_module {
  target = module.agent_channel
  outputs = {
    notification_channel_id = "dummy-channel-id"
  }
}

# The shape of a catalog entry that fed scope_definition in a layered setup: a
# repository URL and a tag, no checkout, and the channel left to the bindings
# layer. The runs that create the channel read its template from the fixture
# checkout: the channel module is overridden whole (see above), and an
# overridden module still evaluates its locals, which index the HTTP read that
# no longer exists.
variables {
  nrn                              = "organization=1:account=2"
  package_slug                     = "dummy-scope"
  package_version                  = "1.2.3"
  service_spec_name                = "Example Functions"
  service_spec_description         = "Example functions"
  service_path                     = "scope"
  repository_scope_template        = "https://example.test/scopes/refs/tags"
  repository_scope_template_branch = "v1.2.3"
  create_agent_channel             = false
}

run "the_scope_type_points_at_the_package_specification_and_needs_no_template" {
  command = plan

  assert {
    condition     = nullplatform_scope_type.this.provider_id == "dummy-spec-id"
    error_message = "The scope type must point at the specification of the package, which the organization does not own"
  }

  assert {
    condition     = nullplatform_scope_type.this.name == "Example Functions" && nullplatform_scope_type.this.description == "Example functions"
    error_message = "The scope type must take its name and description from the same inputs scope_definition takes"
  }

  assert {
    condition     = nullplatform_scope_type.this.provider_type == "service"
    error_message = "A scope type over an installed specification always delegates to a service"
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

  assert {
    condition     = length(data.http.scope_configuration_template) == 0
    error_message = "Without create_scope_configuration nothing may be fetched from the scope repository"
  }
}

run "scope_configuration_is_fetched_from_the_scope_repository_at_the_pinned_ref" {
  command = plan

  variables {
    create_scope_configuration = true
  }

  assert {
    condition     = data.http.scope_configuration_template[0].url == "https://example.test/scopes/refs/tags/v1.2.3/scope/specs/scope-configuration.json.tpl"
    error_message = "The template must be fetched from <repository_scope_template>/<repository_scope_template_branch>/<service_path>/specs/, the URL shape scope_definition uses"
  }

  assert {
    condition     = nullplatform_provider_specification.scope_configuration[0].name == "Example Functions"
    error_message = "The provider specification must take the fetched template's name"
  }

  assert {
    condition     = nullplatform_provider_specification.scope_configuration[0].visible_to == tolist(["organization=1:account=2"])
    error_message = "The provider specification must be visible only at nrn"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_specification.scope_configuration[0].schema).properties.state_bucket.type == "string"
    error_message = "The provider specification schema must be the template's"
  }
}

run "scope_configuration_is_read_from_a_checkout_with_local_specs_path" {
  command = plan

  variables {
    create_scope_configuration       = true
    local_specs_path                 = "./tests/fixtures/scope"
    repository_scope_template        = null
    repository_scope_template_branch = null
  }

  assert {
    condition     = length(data.http.scope_configuration_template) == 0
    error_message = "With local_specs_path the template must not be fetched over HTTP"
  }

  assert {
    condition     = nullplatform_provider_specification.scope_configuration[0].name == "Example Functions"
    error_message = "The provider specification must come from the checkout's scope-configuration.json.tpl"
  }

  assert {
    condition     = nullplatform_provider_specification.scope_configuration[0].visible_to == tolist(["organization=1:account=2"])
    error_message = "The template's NRN placeholder must be replaced by nrn"
  }
}

run "scope_configuration_name_can_be_overridden" {
  command = plan

  variables {
    create_scope_configuration        = true
    scope_configuration_name_override = "Example Functions (account 2)"
  }

  assert {
    condition     = nullplatform_provider_specification.scope_configuration[0].name == "Example Functions (account 2)"
    error_message = "scope_configuration_name_override must override the template's name"
  }
}

run "fetching_a_template_needs_the_repository_and_the_ref" {
  command = plan

  variables {
    create_scope_configuration       = true
    repository_scope_template        = null
    repository_scope_template_branch = null
  }

  expect_failures = [var.repository_scope_template]
}

run "fetching_the_scope_configuration_needs_service_path" {
  command = plan

  variables {
    create_scope_configuration = true
    service_path               = null
  }

  expect_failures = [var.service_path]
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

# The layered shape: the installation, scope type and NRN settings here, the
# channel in the bindings layer. Nothing is fetched, so no repository is needed.
run "the_channel_can_be_left_to_the_bindings_layer" {
  command = plan

  variables {
    service_path                     = null
    repository_scope_template        = null
    repository_scope_template_branch = null
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

run "the_channel_is_created_from_the_same_templates" {
  command = plan

  variables {
    create_agent_channel = true
    agent_tags_selectors = { cluster = "test" }
    local_specs_path     = "./tests/fixtures/scope"
  }

  assert {
    condition     = output.notification_channel_id == "dummy-channel-id"
    error_message = "With create_agent_channel the channel module must be called"
  }
}

run "a_channel_without_tags_is_refused" {
  command = plan

  variables {
    create_agent_channel = true
    agent_tags_selectors = {}
    local_specs_path     = "./tests/fixtures/scope"
  }

  expect_failures = [var.agent_tags_selectors]
}

run "a_channel_without_service_path_is_refused" {
  command = plan

  variables {
    create_agent_channel = true
    agent_tags_selectors = { cluster = "test" }
    local_specs_path     = "./tests/fixtures/scope"
    service_path         = null
  }

  expect_failures = [var.service_path]
}

# The same rule guards the channel template fetched over HTTP. It is not run
# here: the channel module is overridden, and an overridden module still
# evaluates the locals that index its HTTP read, so the run would fail for that
# reason and not for the validation.

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
