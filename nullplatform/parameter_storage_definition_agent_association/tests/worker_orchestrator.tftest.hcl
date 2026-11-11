mock_provider "nullplatform" {}

variables {
  nrn            = "organization=1:account=2"
  tags_selectors = { environment = "test" }
}

run "defaults_to_legacy_exec" {
  command = plan

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].type == "exec"
    error_message = "Without worker_orchestrator the channel must stay a git-clone exec channel."
  }

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].data["cmdline"] == "nullplatform/parameters-provider/parameters/entrypoint"
    error_message = "The exec channel must run script_path."
  }

  assert {
    condition     = !contains(keys(nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].data), "package")
    error_message = "The exec channel must not carry a package."
  }
}

run "worker_orchestrator_emits_package_exec" {
  command = plan

  variables {
    worker_orchestrator = true
  }

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].type == "package-exec"
    error_message = "worker_orchestrator must emit a package-exec channel."
  }

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].data["package"] == "parameters"
    error_message = "The package-exec channel must target the parameters package."
  }

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].data["cmdline"] == "/app/pkg/parameters/entrypoint"
    error_message = "The package-exec channel must run the worker image's baked entrypoint."
  }

  assert {
    condition     = jsondecode(nullplatform_notification_channel.from_template.configuration[0].agent[0].command[0].data["environment"]).NP_PLUGIN == "parameters"
    error_message = "The package-exec channel must set NP_PLUGIN to the package slug."
  }

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].selector["environment"] == "test"
    error_message = "tags_selectors must still select the agent."
  }
}

run "worker_orchestrator_requires_package_slug" {
  command = plan

  variables {
    worker_orchestrator = true
    package_slug        = ""
  }

  expect_failures = [nullplatform_notification_channel.from_template]
}
