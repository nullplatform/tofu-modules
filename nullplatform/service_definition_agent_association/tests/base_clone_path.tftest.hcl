mock_provider "nullplatform" {}

# base_clone_path must match the agent image's $HOME/.np (module.agent.np_basepath).
variables {
  nrn                          = "organization=1:account=2"
  tags_selectors               = { environment = "test" }
  service_specification_slug   = "dummy-service"
  repository_service_spec_repo = "dummy-repo"
  service_path                 = "svc"
}

run "default_base_clone_path_is_unchanged" {
  command = plan

  assert {
    condition     = nullplatform_notification_channel.channel_from_template.configuration[0].agent[0].command[0].data["cmdline"] == "/home/agent/.np/dummy-repo/svc/entrypoint/entrypoint"
    error_message = "Without base_clone_path the cmdline must keep the /home/agent/.np default"
  }
}

run "root_agent_base_clone_path" {
  command = plan

  variables {
    base_clone_path = "/root/.np"
  }

  assert {
    condition     = nullplatform_notification_channel.channel_from_template.configuration[0].agent[0].command[0].data["cmdline"] == "/root/.np/dummy-repo/svc/entrypoint/entrypoint"
    error_message = "A root agent's base_clone_path must reach the cmdline"
  }
}

run "nonroot_agent_base_clone_path" {
  command = plan

  variables {
    base_clone_path = "/home/agent/.np"
  }

  assert {
    condition     = nullplatform_notification_channel.channel_from_template.configuration[0].agent[0].command[0].data["cmdline"] == "/home/agent/.np/dummy-repo/svc/entrypoint/entrypoint"
    error_message = "A nonroot agent's base_clone_path must reach the cmdline"
  }
}
