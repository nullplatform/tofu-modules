mock_provider "nullplatform" {}
mock_provider "external" {}

# No http override: with local_specs_path the template is read from the
# fixture checkout (file() fails the plan if it is missing). The render itself
# is mocked, as in managed_credential.tftest.hcl, because the CI runner has no
# gomplate.
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
  worker_orchestrator      = true
  package_slug             = "dummy-package"
}

run "template_is_read_from_disk" {
  command = plan

  assert {
    condition     = length(data.http.notification_channel_template) == 0
    error_message = "With local_specs_path the channel template must not be fetched over HTTP"
  }

  assert {
    condition     = strcontains(local.notification_channel_template, "Channel to handle example scopes")
    error_message = "The channel template must be the one in local_specs_path"
  }

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].type == "package-exec"
    error_message = "The local template must still become a package-exec channel"
  }
}
