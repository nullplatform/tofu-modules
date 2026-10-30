mock_provider "nullplatform" {}

override_data {
  target = module.installation.data.nullplatform_package.this
  values = {
    id          = "dummy-package-id"
    revision_id = "dummy-revision-id"
    components  = []
  }
}

override_resource {
  target = module.installation.nullplatform_package_installation.this
  values = {
    id              = "dummy-installation-id"
    default_version = "1.2.3"
  }
}

override_resource {
  target = module.agent_channel.nullplatform_notification_channel.channel_from_template
  values = {
    id = "dummy-channel-id"
  }
}

variables {
  nrn                  = "organization=1:account=2"
  package_slug         = "dummy-service"
  package_version      = "1.2.3"
  agent_tags_selectors = { cluster = "test" }
}

run "installs_the_package_and_creates_its_channel" {
  command = apply

  assert {
    condition     = output.installation_id == "dummy-installation-id" && output.installed_version == "1.2.3"
    error_message = "The installation of the package must be reported"
  }

  assert {
    condition     = output.notification_channel_id == "dummy-channel-id"
    error_message = "The agent channel must be created next to the installation"
  }
}

run "a_channel_without_tags_is_refused" {
  command = plan

  variables {
    agent_tags_selectors = {}
  }

  expect_failures = [var.agent_tags_selectors]
}
