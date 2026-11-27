mock_provider "nullplatform" {}
mock_provider "external" {}

# repo_path must match the agent image's $HOME/.np (module.agent.np_basepath).
# The render is mocked (no gomplate in CI), so these check the REPO_PATH it gets.
override_data {
  target = data.external.notification_channel
  values = {
    result = {
      json = "{\"type\":\"agent\",\"source\":[\"service\"],\"configuration\":{\"command\":{\"type\":\"exec\",\"data\":{\"cmdline\":\"echo dummy\"}}},\"filters\":{\"service.specification.slug\":{\"$eq\":\"dummy-scope\"}}}"
    }
  }
}

variables {
  nrn                      = "organization=1:account=2"
  scope_specification_id   = "dummy-specification-id"
  scope_specification_slug = "dummy-scope"
  tags_selectors           = { cluster = "test" }
  local_specs_path         = "./tests/fixtures/scope"
  service_path             = "scope"
}

run "default_repo_path_is_unchanged" {
  command = plan

  assert {
    condition     = strcontains(data.external.notification_channel.program[2], "REPO_PATH='/root/.np/nullplatform/scopes'")
    error_message = "Without repo_path the render must keep the /root/.np default"
  }
}

run "root_agent_repo_path" {
  command = plan

  variables {
    repo_path = "/root/.np/nullplatform/scopes"
  }

  assert {
    condition     = strcontains(data.external.notification_channel.program[2], "REPO_PATH='/root/.np/nullplatform/scopes'")
    error_message = "A root agent's repo_path must reach the render"
  }
}

run "nonroot_agent_repo_path" {
  command = plan

  variables {
    repo_path = "/home/agent/.np/nullplatform/scopes"
  }

  assert {
    condition     = strcontains(data.external.notification_channel.program[2], "REPO_PATH='/home/agent/.np/nullplatform/scopes'")
    error_message = "A nonroot agent's repo_path must reach the render"
  }
}
