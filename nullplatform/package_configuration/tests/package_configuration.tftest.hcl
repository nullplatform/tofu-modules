# Plan only, in every run: the configuration is a local-exec `np package
# configure`, which an override does not skip, so an apply would call the API.

variables {
  nrn          = "organization=1:account=2"
  package_slug = "dummy-package"
}

run "configures_the_place_for_its_agent" {
  command = plan

  variables {
    dimensions = { environment = "development" }
    agent      = { cluster = "dummy-cluster" }
    values     = { domain = "dev.example.com", replicas = 2 }
  }

  assert {
    condition     = local.command == "np package configure --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --values \"$NP_PACKAGE_VALUES\" --dimensions \"$NP_PACKAGE_DIMENSIONS\" --agent \"$NP_PACKAGE_AGENT\" --no-hooks"
    error_message = "The command must name the place, the agent and the values, each taken from the environment"
  }

  assert {
    condition     = local.environment.NP_PACKAGE_NRN == "organization=1:account=2" && local.environment.NP_PACKAGE_SLUG == "dummy-package"
    error_message = "The place and the package must be the ones given"
  }

  assert {
    condition     = local.environment.NP_PACKAGE_DIMENSIONS == "environment=development" && local.environment.NP_PACKAGE_AGENT == "cluster=dummy-cluster"
    error_message = "Dimensions and agent tags must be written as key=value"
  }

  assert {
    condition     = jsondecode(local.environment.NP_PACKAGE_VALUES) == { domain = "dev.example.com", replicas = 2 }
    error_message = "The values must travel as one JSON document, with their types"
  }
}

# A package brings as many forms as it needs: the values are one group per
# form, each laid out as its form is.
run "values_are_a_group_per_form_nested_as_the_form_is" {
  command = plan

  variables {
    values = {
      scope     = { networking = { domain_name = "dev.example.com", application_domain = "false" } }
      placement = { cluster = { namespace = "dummy-namespace", create_namespace_if_not_exist = true } }
    }
  }

  assert {
    condition     = jsondecode(local.environment.NP_PACKAGE_VALUES).scope.networking.domain_name == "dev.example.com"
    error_message = "A form's group must reach the command nested as given"
  }

  assert {
    condition     = jsondecode(local.environment.NP_PACKAGE_VALUES).placement.cluster.create_namespace_if_not_exist == true
    error_message = "Each form keeps its own group, with its types"
  }
}

run "a_place_with_no_dimensions_and_no_agent" {
  command = plan

  assert {
    condition     = local.command == "np package configure --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --values \"$NP_PACKAGE_VALUES\" --no-hooks"
    error_message = "With no dimensions and no agent the command must give neither flag, so no channel is created"
  }

  assert {
    condition     = local.environment.NP_PACKAGE_VALUES == "{}"
    error_message = "No values is an empty document"
  }
}

run "pairs_are_joined_in_a_stable_order" {
  command = plan

  variables {
    dimensions = { environment = "production", country = "dummy-country" }
    agent      = { region = "dummy-region", cluster = "dummy-cluster" }
  }

  assert {
    condition     = local.environment.NP_PACKAGE_DIMENSIONS == "country=dummy-country,environment=production"
    error_message = "Dimensions must be joined by commas in key order, so the same place always reads the same"
  }

  assert {
    condition     = local.environment.NP_PACKAGE_AGENT == "cluster=dummy-cluster,region=dummy-region"
    error_message = "Agent tags must be joined by commas in key order"
  }
}

# A value is never part of the shell command, whatever it holds.
run "values_never_reach_the_shell" {
  command = plan

  variables {
    values = { note = "it's \"quoted\"; $(whoami) `id` $HOME" }
  }

  assert {
    condition     = !strcontains(local.command, "whoami") && !strcontains(local.command, "quoted")
    error_message = "A value must not appear in the command line"
  }

  assert {
    condition     = jsondecode(local.environment.NP_PACKAGE_VALUES).note == "it's \"quoted\"; $(whoami) `id` $HOME"
    error_message = "The value must reach the command unchanged, in the environment"
  }
}

run "components_already_there_are_given_by_name" {
  command = plan

  variables {
    imports = { values = "dummy-provider-id", channel = "123" }
  }

  assert {
    condition     = strcontains(local.command, "--import channel=123 --import values=dummy-provider-id")
    error_message = "Each import must be passed as --import name=id, in name order"
  }
}

run "the_packages_own_lines_run_only_in_its_directory" {
  command = plan

  variables {
    package_dir = "/dummy/checkout/of/the/package"
  }

  assert {
    condition     = strcontains(local.command, "--dir \"$NP_PACKAGE_DIR\"") && !strcontains(local.command, "--no-hooks")
    error_message = "With package_dir the command must run in that directory, with the package's lines"
  }

  assert {
    condition     = local.environment.NP_PACKAGE_DIR == "/dummy/checkout/of/the/package"
    error_message = "The directory must be the one given"
  }
}

run "a_change_of_what_was_given_runs_it_again" {
  command = plan

  variables {
    dimensions      = { environment = "staging" }
    agent           = { cluster = "dummy-cluster" }
    values          = { domain = "stg.example.com" }
    package_version = "1.2.3"
  }

  assert {
    condition     = terraform_data.this.triggers_replace.values.domain == "stg.example.com" && terraform_data.this.triggers_replace.dimensions.environment == "staging"
    error_message = "The place and its values must be part of what replaces the configuration"
  }

  assert {
    condition     = terraform_data.this.triggers_replace.agent.cluster == "dummy-cluster" && terraform_data.this.triggers_replace.package_version == "1.2.3"
    error_message = "The agent and the installed version must be part of what replaces the configuration"
  }

  assert {
    condition     = output.dimensions.environment == "staging" && output.agent.cluster == "dummy-cluster" && output.nrn == "organization=1:account=2"
    error_message = "The outputs must say which place was configured and for which agent"
  }
}

run "a_dimension_that_would_break_the_pairs_is_refused" {
  command = plan

  variables {
    dimensions = { environment = "production,staging" }
  }

  expect_failures = [var.dimensions]
}

run "an_agent_tag_that_would_break_the_pairs_is_refused" {
  command = plan

  variables {
    agent = { cluster = "a=b" }
  }

  expect_failures = [var.agent]
}

run "an_import_that_is_not_a_plain_id_is_refused" {
  command = plan

  variables {
    imports = { channel = "123; rm -rf /" }
  }

  expect_failures = [var.imports]
}
