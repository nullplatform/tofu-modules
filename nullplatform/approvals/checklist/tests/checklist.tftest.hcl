mock_provider "nullplatform" {
  mock_resource "nullplatform_checklist_specification" {
    defaults = {
      current_version_id = "spec_0123456789abcdef"
      version            = 3
    }
  }
}

# A one-item checklist at an account.
variables {
  nrn  = "organization=1:account=2"
  name = "prod-deploy-gate"

  definition = {
    items = [
      {
        id       = "peer_sign_off"
        type     = "manual"
        behavior = "gate"
        severity = "major"
        title    = "A peer signs off the deploy"
      },
    ]
  }
}

# Keys the module does not know about, nested objects and numbers included,
# reach the API as given: the module validates nothing but items.
run "the_definition_is_sent_whole" {
  command = plan

  variables {
    definition = {
      aggregation       = { type = "derived" }
      execution_trigger = "automatic_approval"
      annotations       = { owner = "payments", reviewed = "2026-01-15" }
      items = [
        {
          id       = "coverage_gate"
          type     = "condition"
          behavior = "gate"
          severity = "major"
          title    = "Line coverage at least 80%"
          query    = { "build.metadata.coverage.lines.percent" = { "$gte" = 80 } }
        },
      ]
    }
  }

  assert {
    condition     = nullplatform_checklist_specification.this.definition == jsonencode(var.definition)
    error_message = "The definition must be sent as jsonencode of the object given"
  }

  assert {
    condition     = jsondecode(nullplatform_checklist_specification.this.definition).annotations.owner == "payments"
    error_message = "A key the module does not know must reach the API"
  }

  assert {
    condition     = jsondecode(nullplatform_checklist_specification.this.definition).items[0].query["build.metadata.coverage.lines.percent"]["$gte"] == 80
    error_message = "Numbers must reach the API as numbers"
  }
}

run "nrn_and_name_reach_the_specification" {
  command = plan

  assert {
    condition     = nullplatform_checklist_specification.this.nrn == "organization=1:account=2"
    error_message = "The specification must live at the nrn given"
  }

  assert {
    condition     = nullplatform_checklist_specification.this.name == "prod-deploy-gate"
    error_message = "The specification must take the name given"
  }
}

run "the_description_defaults_to_none" {
  command = plan

  assert {
    condition     = nullplatform_checklist_specification.this.description == null
    error_message = "Without a description the specification must have none"
  }
}

run "the_description_reaches_the_specification" {
  command = plan

  variables {
    description = "Production deploys need a peer sign-off"
  }

  assert {
    condition     = nullplatform_checklist_specification.this.description == "Production deploys need a peer sign-off"
    error_message = "The description must reach the specification as given"
  }
}

run "the_outputs_follow_the_specification" {
  command = apply

  assert {
    condition     = output.current_version_id == "spec_0123456789abcdef"
    error_message = "current_version_id must be the specification's current version"
  }

  assert {
    condition     = output.version == 3
    error_message = "version must be the number of the current version"
  }

  assert {
    condition     = output.id == nullplatform_checklist_specification.this.id
    error_message = "id must be the specification's id"
  }

  assert {
    condition     = output.name == "prod-deploy-gate" && output.nrn == "organization=1:account=2"
    error_message = "name and nrn must be the specification's"
  }
}

run "a_definition_without_items_is_refused" {
  command = plan

  variables {
    definition = {
      execution_trigger = "explicit"
    }
  }

  expect_failures = [var.definition]
}

run "a_definition_passed_as_a_json_string_is_refused" {
  command = plan

  variables {
    definition = "{\"items\": []}"
  }

  expect_failures = [var.definition]
}

run "the_production_gate_example_plans" {
  command = plan

  module {
    source = "./examples/production-gate"
  }
}
