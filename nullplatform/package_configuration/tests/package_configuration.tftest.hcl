# No run here starts the real `np` or reaches any API: np_bin is a stand-in
# (tests/np-stub.sh) that logs what it was asked and answers a place's record.
# Most runs only plan; the ones that apply check what the stand-in was asked.

variables {
  nrn          = "organization=1:account=2"
  package_slug = "dummy-package"
  np_bin       = "./tests/np-stub.sh"
}

run "the_stand_in_starts_with_an_empty_log" {
  command = apply

  module {
    source = "./tests/setup"
  }
}

run "configures_the_place_for_its_agent" {
  command = plan

  variables {
    dimensions = { environment = "development" }
    agent      = { cluster = "dummy-cluster" }
    values     = { domain = "dev.example.com", replicas = 2 }
  }

  assert {
    condition     = local.command == "\"$NP_PACKAGE_BIN\" package configure --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --values \"$NP_PACKAGE_VALUES\" --dimensions \"$NP_PACKAGE_DIMENSIONS\" --agent \"$NP_PACKAGE_AGENT\""
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
    condition     = local.command == "\"$NP_PACKAGE_BIN\" package configure --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --values \"$NP_PACKAGE_VALUES\""
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

# The package's own tasks travel in the manifest its version keeps, so they
# run with no directory given. A directory is only for a package in the making.
run "the_packages_tasks_run_with_no_directory" {
  command = plan

  assert {
    condition     = !strcontains(local.command, "--no-hooks") && !strcontains(local.command, "--dir")
    error_message = "By default the package's tasks run, and no directory is asked for"
  }
}

run "the_packages_tasks_can_be_left_out" {
  command = plan

  variables {
    dimensions = { environment = "development" }
    run_hooks  = false
  }

  assert {
    condition     = strcontains(local.command, "--no-hooks")
    error_message = "With run_hooks off the command must leave out what the package's tasks make"
  }

  assert {
    condition     = local.remove_command == "\"$NP_PACKAGE_BIN\" package unconfigure --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --dimensions \"$NP_PACKAGE_DIMENSIONS\" --no-hooks"
    error_message = "Removing the place must leave the same components alone"
  }
}

run "a_package_in_the_making_is_read_from_its_directory" {
  command = plan

  variables {
    package_dir = "/dummy/checkout/of/the/package"
  }

  assert {
    condition     = strcontains(local.command, "--dir \"$NP_PACKAGE_DIR\"") && !strcontains(local.command, "--no-hooks")
    error_message = "With package_dir the command must read the package from that directory"
  }

  assert {
    condition     = local.environment.NP_PACKAGE_DIR == "/dummy/checkout/of/the/package"
    error_message = "The directory must be the one given"
  }
}

# Destroying the configuration removes the place: the command and what it
# needs are kept on the resource, since a destroy reads nothing else.
run "destroying_it_removes_the_place" {
  command = plan

  variables {
    dimensions = { environment = "production", country = "dummy-country" }
    agent      = { cluster = "dummy-cluster" }
    values     = { domain = "example.com" }
  }

  assert {
    condition     = terraform_data.place.input.command == "\"$NP_PACKAGE_BIN\" package unconfigure --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --dimensions \"$NP_PACKAGE_DIMENSIONS\""
    error_message = "The place must keep the command that removes it, naming only the place"
  }

  assert {
    condition     = terraform_data.place.input.environment.NP_PACKAGE_NRN == "organization=1:account=2" && terraform_data.place.input.environment.NP_PACKAGE_DIMENSIONS == "country=dummy-country,environment=production"
    error_message = "The place must keep what names it, for the day it is removed"
  }

  assert {
    condition     = !strcontains(terraform_data.place.input.command, "example.com") && !strcontains(terraform_data.place.input.command, "--agent")
    error_message = "Removing a place takes neither its values nor its agent"
  }
}

run "a_place_with_no_dimensions_is_removed_by_its_nrn" {
  command = plan

  assert {
    condition     = local.remove_command == "\"$NP_PACKAGE_BIN\" package unconfigure --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\""
    error_message = "With no dimensions the place is everything under the nrn"
  }
}

# A new value updates the place where it is: only what the package gets there
# runs again, and the place itself is not removed and made again.
run "a_change_of_what_was_given_runs_it_again_and_keeps_the_place" {
  command = plan

  variables {
    dimensions      = { environment = "staging" }
    agent           = { cluster = "dummy-cluster" }
    values          = { domain = "stg.example.com" }
    package_version = "1.2.3"
  }

  assert {
    condition     = terraform_data.this.triggers_replace.values.domain == "stg.example.com" && terraform_data.this.triggers_replace.agent.cluster == "dummy-cluster" && terraform_data.this.triggers_replace.package_version == "1.2.3"
    error_message = "The values, the agent and the installed version must be part of what runs the configuration again"
  }

  assert {
    condition     = terraform_data.place.triggers_replace.dimensions.environment == "staging" && terraform_data.place.triggers_replace.nrn == "organization=1:account=2" && terraform_data.place.triggers_replace.package_slug == "dummy-package"
    error_message = "Only what names the place may replace it"
  }

  assert {
    condition     = !can(terraform_data.place.triggers_replace.values) && !can(terraform_data.place.triggers_replace.agent) && !can(terraform_data.place.triggers_replace.package_version)
    error_message = "A new value, agent or version must not remove the place and make it again"
  }

  assert {
    condition     = output.dimensions.environment == "staging" && output.agent.cluster == "dummy-cluster" && output.nrn == "organization=1:account=2"
    error_message = "The outputs must say which place was configured and for which agent"
  }
}

# What the installation records for the place is read back as outputs, after
# the command ran. This run applies: the stand-in is asked to configure, then
# for the record.
run "the_record_is_read_back_for_this_place" {
  command = apply

  variables {
    dimensions = { environment = "production" }
    agent      = { cluster = "dummy-cluster" }
    values     = { domain = "example.com" }
  }

  assert {
    condition     = strcontains(local.record_query, ".nrn == \"organization=1:account=2\"") && strcontains(local.record_query, "== {\"environment\":\"production\"}")
    error_message = "The record must be read for exactly this place: its nrn and its dimensions"
  }

  assert {
    condition     = data.external.record[0].program[0] == "sh" && data.external.record[0].program[4] == "organization=1:account=2" && data.external.record[0].program[5] == "dummy-package"
    error_message = "The place and the package must reach the program as arguments, never inside its script"
  }

  assert {
    condition     = !strcontains(local.record_script, "organization=1") && !strcontains(local.record_script, "dummy-package")
    error_message = "Nothing given is part of the script that reads the record"
  }

  assert {
    condition     = output.status == "active" && output.version == "1.2.3"
    error_message = "The status and the version must be the ones the installation records"
  }

  assert {
    condition     = output.outputs["placement.cluster.namespace"] == "dummy-namespace" && output.outputs.replicas == 2
    error_message = "What the package's tasks answered must come back with its names and types"
  }

  assert {
    condition     = output.resources[0].name == "channel" && output.resources[0].id == "123" && output.resources[0].ref == "notification_channel/channel" && output.resources[0].origin == "created"
    error_message = "What was created at the place must come back with its id, its ref and its origin"
  }

  assert {
    condition     = strcontains(file("${path.module}/tests/.np-stub.log"), "package configure --nrn organization=1:account=2 --slug dummy-package --values {\"domain\":\"example.com\"} --dimensions environment=production --agent cluster=dummy-cluster")
    error_message = "The command must have run once, with the place, its agent and its values"
  }

  assert {
    condition     = strcontains(file("${path.module}/tests/.np-stub.log"), "package status --nrn organization=1:account=2 --slug dummy-package --format json --query")
    error_message = "The record must have been asked for after the command ran"
  }
}

# The same place given new values: the command runs again and the place is not
# removed in between. The stand-in's log says what ran since the last run.
run "a_new_value_configures_the_place_again_without_removing_it" {
  command = apply

  variables {
    dimensions = { environment = "production" }
    agent      = { cluster = "dummy-cluster" }
    values     = { domain = "new.example.com" }
  }

  assert {
    condition     = strcontains(file("${path.module}/tests/.np-stub.log"), "--values {\"domain\":\"new.example.com\"}")
    error_message = "A new value must run the command again with it"
  }

  assert {
    condition     = !strcontains(file("${path.module}/tests/.np-stub.log"), "package unconfigure")
    error_message = "A new value must not remove the place"
  }
}

# Another place: the one before is removed, then the new one configured.
run "another_place_removes_the_one_before" {
  command = apply

  variables {
    dimensions = { environment = "staging" }
    agent      = { cluster = "dummy-cluster" }
    values     = { domain = "new.example.com" }
  }

  assert {
    condition     = strcontains(file("${path.module}/tests/.np-stub.log"), "package unconfigure --nrn organization=1:account=2 --slug dummy-package --dimensions environment=production")
    error_message = "Leaving a place must remove it, named by its nrn and dimensions only"
  }

  assert {
    condition     = strcontains(file("${path.module}/tests/.np-stub.log"), "package configure --nrn organization=1:account=2 --slug dummy-package --values {\"domain\":\"new.example.com\"} --dimensions environment=staging")
    error_message = "The new place must be configured"
  }
}

run "a_key_given_never_reaches_the_programs_arguments" {
  command = plan

  variables {
    np_api_key = "dummy-key"
  }

  assert {
    condition     = alltrue([for argument in data.external.record[0].program : !strcontains(argument, "dummy-key")])
    error_message = "The key must reach np through its environment, never as an argument"
  }

  assert {
    condition     = nonsensitive(data.external.record[0].query.api_key) == "dummy-key"
    error_message = "The key must be handed to the program on its input"
  }
}

run "the_record_is_not_read_when_asked_not_to" {
  command = plan

  variables {
    read_record = false
  }

  assert {
    condition     = length(data.external.record) == 0
    error_message = "With read_record off no program may run at plan time"
  }

  assert {
    condition     = output.status == null && output.outputs == null && output.resources == null
    error_message = "With read_record off the outputs read from the record are null"
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
