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

# Plan only below: applying the manifest is a local-exec `np package install`,
# which an override does not skip, so an apply would call the API.
run "the_manifest_is_not_applied_unless_asked" {
  command = plan

  assert {
    condition     = length(terraform_data.manifest) == 0
    error_message = "A plain installation must not run np: existing callers keep what they have"
  }
}

run "the_manifest_is_applied_for_the_installed_version" {
  command = plan

  variables {
    apply_manifest = true
  }

  assert {
    condition     = length(terraform_data.manifest) == 1
    error_message = "apply_manifest must add the step that creates what the manifest marks on install"
  }

  assert {
    condition     = local.manifest_command == "np package install --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --version \"$NP_PACKAGE_VERSION\" --no-hooks"
    error_message = "The command must install the same package at the same NRN and version as the installation, without the package's own lines"
  }

  assert {
    condition     = local.manifest_environment.NP_PACKAGE_NRN == "organization=1:account=2" && local.manifest_environment.NP_PACKAGE_SLUG == "dummy-package" && local.manifest_environment.NP_PACKAGE_VERSION == "1.2.3"
    error_message = "The NRN, the package and the version must be the ones the installation pins"
  }
}

run "the_manifest_step_takes_imports_and_the_package_directory" {
  command = plan

  variables {
    apply_manifest   = true
    manifest_imports = { scope-type = "812", configuration = "dummy-specification-id" }
    package_dir      = "/dummy/checkout/of/the/package"
  }

  assert {
    condition     = local.manifest_command == "np package install --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --version \"$NP_PACKAGE_VERSION\" --dir \"$NP_PACKAGE_DIR\" --import configuration=dummy-specification-id --import scope-type=812"
    error_message = "With package_dir the package's lines run there, and each import is passed as --import name=id in name order"
  }

  assert {
    condition     = local.manifest_environment.NP_PACKAGE_DIR == "/dummy/checkout/of/the/package"
    error_message = "The directory must be the one given"
  }

  assert {
    condition     = terraform_data.manifest[0].triggers_replace.imports.scope-type == "812" && terraform_data.manifest[0].triggers_replace.package_dir == "/dummy/checkout/of/the/package"
    error_message = "A change of what was given must run the step again"
  }
}

run "a_manifest_import_that_is_not_a_plain_id_is_refused" {
  command = plan

  variables {
    apply_manifest   = true
    manifest_imports = { scope-type = "812 && whoami" }
  }

  expect_failures = [var.manifest_imports]
}
