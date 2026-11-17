mock_provider "nullplatform" {}


# A release of a scope repository, as the publish-package workflow applies
# it: the tag and the digest it pushed, the specs from the fixture checkout.
variables {
  nrn                      = "organization=4"
  release_tag              = "v1.2.3"
  image_digest             = "sha256:5d1eadcbe8fec3bedcf1ad535904a256336e5270d3f0964661e830be6c8ee02a"
  image_repository         = "nullplatform/scopes/example"
  package_slug             = "np-example-functions"
  service_spec_name        = "Example Functions"
  service_spec_description = "Example functions"
  action_spec_names        = ["create-scope"]
  service_path             = "scope"
  local_specs_path         = "./tests/fixtures/scope"
}

run "a_release_publishes_its_tag_as_the_package_version_and_promotes_it" {
  command = plan

  assert {
    condition     = output.package_version == "1.2.3"
    error_message = "The package version must be the release tag without the v"
  }

  assert {
    condition     = output.package_promoted == true
    error_message = "A stable release must become the package default"
  }

  assert {
    condition     = output.service_specification_slug == "np-example-functions"
    error_message = "The specification takes the package slug unless service_slug says otherwise"
  }
}

run "a_prerelease_is_published_without_moving_the_default" {
  command = plan

  variables {
    release_tag = "v1.2.3-rc.1"
  }

  assert {
    condition     = output.package_version == "1.2.3-rc.1"
    error_message = "A prerelease keeps its full semver as the package version"
  }

  assert {
    condition     = output.package_promoted == false
    error_message = "A prerelease must not become the package default"
  }
}

run "promote_default_forces_the_default_either_way" {
  command = plan

  variables {
    release_tag     = "v1.2.3-rc.1"
    promote_default = true
  }

  assert {
    condition     = output.package_promoted == true
    error_message = "promote_default = true must promote even a prerelease"
  }
}

run "a_tag_that_is_not_a_release_is_refused" {
  command = plan

  variables {
    release_tag = "1.2.3"
  }

  expect_failures = [var.release_tag]
}

run "a_digest_that_is_not_sha256_is_refused" {
  command = plan

  variables {
    image_digest = "latest"
  }

  expect_failures = [var.image_digest]
}
