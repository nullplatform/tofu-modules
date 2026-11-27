mock_provider "nullplatform" {}

# repo_path must match the agent image's $HOME/.np (module.agent.np_basepath).
variables {
  nrn              = "organization=1:account=2"
  np_api_key       = "test"
  local_specs_path = "./tests/fixtures/scope"
  service_path     = "scope"
}

run "default_repo_path_is_unchanged" {
  command = plan

  assert {
    condition     = local.dependent_env_vars.REPO_PATH == "/root/.np/nullplatform/scopes"
    error_message = "Without repo_path the templates must keep getting the /root/.np default"
  }
}

run "root_agent_repo_path" {
  command = plan

  variables {
    repo_path = "/root/.np/nullplatform/scopes"
  }

  assert {
    condition     = local.dependent_env_vars.REPO_PATH == "/root/.np/nullplatform/scopes"
    error_message = "A root agent's repo_path must reach the templates"
  }
}

run "nonroot_agent_repo_path" {
  command = plan

  variables {
    repo_path = "/home/agent/.np/nullplatform/scopes"
  }

  assert {
    condition     = local.dependent_env_vars.REPO_PATH == "/home/agent/.np/nullplatform/scopes"
    error_message = "A nonroot agent's repo_path must reach the templates"
  }
}
