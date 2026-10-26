mock_provider "nullplatform" {}

# No override for the http data sources: with local_specs_path they must not
# exist, and every template is read from the fixture checkout. Templates are
# rendered by the real gomplate through data.external.
variables {
  nrn                        = "organization=1:account=2"
  np_api_key                 = "test"
  local_specs_path           = "./tests/fixtures/scope"
  service_path               = "scope"
  create_scope_configuration = true
}

run "templates_are_read_from_disk" {
  command = plan

  assert {
    condition     = length(data.http.service_spec_template) == 0 && length(data.http.scope_type_template) == 0
    error_message = "With local_specs_path the spec and scope type templates must not be fetched over HTTP"
  }

  assert {
    condition     = length(data.http.action_templates) == 0 && length(data.http.scope_configuration_template) == 0
    error_message = "With local_specs_path the action and scope-configuration templates must not be fetched over HTTP"
  }

  assert {
    condition     = local.service_spec_parsed.attributes.nrn == "organization=1:account=2"
    error_message = "The local service spec must be rendered with the NRN"
  }

  assert {
    condition     = nullplatform_scope_type.from_template.provider_type == "service"
    error_message = "The scope type must come from the local scope-type-definition.json.tpl"
  }

  assert {
    condition     = nullplatform_action_specification.from_templates["create-scope"].type == "create"
    error_message = "The actions listed in the local service spec must be read from specs/actions/"
  }

  assert {
    condition     = nullplatform_provider_specification.from_scope_configuration[0].name == "Example Functions"
    error_message = "The scope configuration must come from the local scope-configuration.json.tpl"
  }
}

run "package_declares_its_required_providers" {
  command = plan

  variables {
    package = {
      version = "1.0.0"
      requires_providers = [
        { category = "scope-configurations" },
        { category = "metrics", optional = true },
      ]
      artifacts = [{ resource_id = "artifact-1", resource_revision_id = "revision-1" }]
    }
  }

  assert {
    condition = [for r in nullplatform_package.this[0].requires_provider : [r.category, r.optional]] == [
      ["scope-configurations", false],
      ["metrics", true],
    ]
    error_message = "requires_providers should become the package's requires_provider blocks, in order."
  }
}
