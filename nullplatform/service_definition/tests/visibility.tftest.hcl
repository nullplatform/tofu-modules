mock_provider "nullplatform" {}
mock_provider "http" {}

variables {
  nrn               = "organization=1:account=2"
  git_provider      = "local"
  local_specs_path  = "./tests/fixtures/svc"
  service_path      = "svc"
  service_name      = "Test Service"
  repository_branch = "v1.0.0"
  available_links   = []
}

run "defaults_to_nrn" {
  command = plan

  assert {
    condition     = nullplatform_service_specification.from_template.visible_to == tolist(["organization=1:account=2"])
    error_message = "Without visible_to, visibility should be var.nrn."
  }
}

run "extra_nrns_are_appended" {
  command = plan

  variables {
    extra_visibile_to_nrns = ["organization=1:account=3"]
  }

  assert {
    condition     = nullplatform_service_specification.from_template.visible_to == tolist(["organization=1:account=2", "organization=1:account=3"])
    error_message = "extra_visibile_to_nrns should be appended to var.nrn."
  }
}

run "visible_to_replaces_default" {
  command = plan

  variables {
    visible_to             = ["organization=1:account=9"]
    extra_visibile_to_nrns = ["organization=1:account=3"]
  }

  assert {
    condition     = nullplatform_service_specification.from_template.visible_to == tolist(["organization=1:account=9"])
    error_message = "visible_to should replace var.nrn and extra_visibile_to_nrns."
  }
}

run "visible_to_rejects_empty_list" {
  command = plan

  variables {
    visible_to = []
  }

  expect_failures = [var.visible_to]
}

# visible_to only narrows the specification: the package keeps var.nrn as owner
# and default visibility, so narrowing the spec does not force a package replacement.
run "visible_to_does_not_touch_package" {
  command = plan

  variables {
    nrn        = "organization=1"
    visible_to = ["organization=1:account=9"]
    package    = { version = "1.0.0" }
  }

  assert {
    condition     = nullplatform_service_specification.from_template.visible_to == tolist(["organization=1:account=9"])
    error_message = "The specification should use visible_to."
  }

  assert {
    condition     = nullplatform_package.this[0].nrn == "organization=1"
    error_message = "The package should keep var.nrn as its owner."
  }

  assert {
    condition     = nullplatform_package.this[0].visible_to == tolist(["organization=1"])
    error_message = "The package visibility should not follow visible_to."
  }
}

# The providers an organization must hold before installing the package travel
# on the package, in order; none declared leaves the package without them.
run "package_declares_its_required_providers" {
  command = plan

  variables {
    package = {
      version = "1.0.0"
      requires_providers = [
        { category = "cloud-providers" },
        { specification = "datadog", optional = true },
      ]
    }
  }

  assert {
    condition = [for r in nullplatform_package.this[0].requires_provider : "${coalesce(r.category, "-")}|${coalesce(r.specification, "-")}|${r.optional}"] == [
      "cloud-providers|-|false",
      "-|datadog|true",
    ]
    error_message = "requires_providers should become the package's requires_provider blocks, in order."
  }
}

run "package_without_required_providers" {
  command = plan

  variables {
    package = { version = "1.0.0" }
  }

  assert {
    condition     = length(nullplatform_package.this[0].requires_provider) == 0
    error_message = "A package that declares nothing should carry no requires_provider block."
  }
}

run "required_provider_names_exactly_one_of_category_or_specification" {
  command = plan

  variables {
    package = {
      version            = "1.0.0"
      requires_providers = [{ category = "cloud-providers", specification = "aws" }]
    }
  }

  expect_failures = [var.package]
}
