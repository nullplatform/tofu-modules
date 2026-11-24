mock_provider "nullplatform" {}
mock_provider "http" {}
mock_provider "external" {}

override_data {
  target = data.http.notification_channel_template
  values = {
    status_code   = 200
    response_body = "{}"
  }
}

override_data {
  target = data.external.notification_channel
  values = {
    result = {
      json = "{\"type\":\"agent\",\"source\":[\"service\"],\"configuration\":{\"command\":{\"type\":\"exec\",\"data\":{\"cmdline\":\"echo dummy\"}}},\"filters\":{\"service.specification.slug\":{\"$eq\":\"dummy\"}}}"
    }
  }
}

variables {
  nrn                      = "organization=1:account=2"
  scope_specification_id   = "dummy-specification-id"
  scope_specification_slug = "dummy-scope"
  tags_selectors           = { environment = "test" }
  override_repo_path       = "/root/.np/dummy/overrides-repo"
  overrides_service_path   = "/overrides"
}

run "legacy_channel_appends_the_override_flag" {
  command = plan

  variables {
    enabled_override = true
  }

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].data["cmdline"] == "echo dummy --overrides-path=/root/.np/dummy/overrides-repo/overrides"
    error_message = "The legacy channel must append --overrides-path to the template's cmdline."
  }
}

run "legacy_channel_without_override_keeps_cmdline" {
  command = plan

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].data["cmdline"] == "echo dummy"
    error_message = "Without enabled_override the legacy cmdline must be untouched."
  }
}

# package_slug is set so only the enabled_override precondition can fail.
run "worker_channel_rejects_the_override" {
  command = plan

  variables {
    worker_orchestrator = true
    package_slug        = "dummy-package"
    enabled_override    = true
  }

  expect_failures = [nullplatform_notification_channel.from_template]
}

run "worker_channel_without_override_plans" {
  command = plan

  variables {
    worker_orchestrator = true
    package_slug        = "dummy-package"
  }

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].type == "package-exec"
    error_message = "A worker channel without override must still plan as package-exec."
  }

  assert {
    condition     = !strcontains(nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].data["cmdline"], "--overrides-path")
    error_message = "The worker command must be the baked entrypoint, without --overrides-path."
  }
}
