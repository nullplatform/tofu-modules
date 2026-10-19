mock_provider "nullplatform" {}
mock_provider "http" {}

variables {
  nrn               = "organization=1:account=2"
  git_provider      = "local"
  local_specs_path  = "./tests/fixtures"
  repository_branch = "main"
  service_path      = "fixture"
  service_name      = "Fixture"
  available_actions = ["with-external", "without-external"]
  available_links   = []
}

run "action_spec_passes_external_through" {
  command = plan

  assert {
    condition     = jsondecode(nullplatform_action_specification.from_templates["with-external"].external).action == "list-things"
    error_message = "external.action should reach the action specification"
  }

  assert {
    condition     = jsondecode(nullplatform_action_specification.from_templates["with-external"].external).output_schema.required == ["things"]
    error_message = "external.output_schema should reach the action specification"
  }
}

run "action_spec_without_external_sends_null" {
  command = plan

  assert {
    condition     = nullplatform_action_specification.from_templates["without-external"].external == null
    error_message = "an action spec without external should not send one"
  }
}
