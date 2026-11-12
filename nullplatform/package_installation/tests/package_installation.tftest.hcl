mock_provider "nullplatform" {}

override_data {
  target = data.nullplatform_package.this
  values = {
    id          = "dummy-package-id"
    revision_id = "dummy-revision-3"
    components = [
      { name = "spec", resource_type = "service_specification", resource_id = "dummy-spec-id", resource_revision_id = "dummy-spec-snapshot", parent_id = null },
      { name = "create", resource_type = "action_specification", resource_id = "dummy-action-id", resource_revision_id = "dummy-action-snapshot", parent_id = "dummy-spec-id" },
      { name = "worker-image", resource_type = "artifact", resource_id = "dummy-artifact-id", resource_revision_id = "dummy-artifact-revision", parent_id = null },
    ]
  }
}

override_data {
  target = data.nullplatform_service_specification.this
  values = {
    slug = "dummy-spec"
  }
}

variables {
  nrn             = "organization=1:account=2"
  package_slug    = "dummy-package"
  package_version = "1.2.3"
}

run "installs_the_revision_of_the_requested_version" {
  command = plan

  assert {
    condition     = data.nullplatform_package.this.visible_at == "organization=1:account=2" && data.nullplatform_package.this.version == "1.2.3"
    error_message = "The package must be looked up as visible at nrn, at the requested version"
  }

  assert {
    condition     = nullplatform_package_installation.this.package_id == "dummy-package-id"
    error_message = "The installation must install the package found"
  }

  assert {
    condition     = nullplatform_package_installation.this.default_revision_id == "dummy-revision-3"
    error_message = "New services must be born with the revision of the requested version, not the package default"
  }

  assert {
    condition     = output.service_specification_ids == ["dummy-spec-id"]
    error_message = "Only the service specifications of the bill of materials must be reported"
  }
}

# Apply: the specification is read once the installation exists, so its slug
# is unknown at plan on a first install.
run "outputs_carry_the_names_service_definition_uses" {
  command = apply

  override_resource {
    target = nullplatform_package_installation.this
    values = {
      id              = "dummy-installation-id"
      default_version = "1.2.3"
    }
  }

  assert {
    condition     = output.service_specification_id == "dummy-spec-id"
    error_message = "service_specification_id must be the package's one specification"
  }

  assert {
    condition     = output.service_specification_slug == "dummy-spec"
    error_message = "service_specification_slug must be read from the specification"
  }

  assert {
    condition     = output.package_default_version == "1.2.3"
    error_message = "package_default_version must be the installed version"
  }
}

run "a_package_with_two_specifications_reports_none" {
  command = plan

  override_data {
    target = data.nullplatform_package.this
    values = {
      id          = "dummy-package-id"
      revision_id = "dummy-revision-3"
      components = [
        { name = "server", resource_type = "service_specification", resource_id = "dummy-spec-a", resource_revision_id = "dummy-a", parent_id = null },
        { name = "db", resource_type = "service_specification", resource_id = "dummy-spec-b", resource_revision_id = "dummy-b", parent_id = null },
      ]
    }
  }

  assert {
    condition     = output.service_specification_id == null && output.service_specification_slug == null
    error_message = "With more than one specification there is no single id or slug to report"
  }

  assert {
    condition     = length(output.service_specification_ids) == 2
    error_message = "service_specification_ids must still list every specification"
  }
}

run "visible_to_reaches_the_installation" {
  command = plan

  variables {
    visible_to = ["organization=1:account=2:namespace=3"]
  }

  assert {
    condition     = nullplatform_package_installation.this.visible_to == tolist(["organization=1:account=2:namespace=3"])
    error_message = "visible_to must reach the installation unchanged"
  }
}

run "a_tag_is_not_a_version" {
  command = plan

  variables {
    package_version = "v1.2.3"
  }

  expect_failures = [var.package_version]
}
