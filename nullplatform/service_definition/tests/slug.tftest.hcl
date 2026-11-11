mock_provider "nullplatform" {}
mock_provider "http" {}

# The slug a service specification and its link specifications are created
# with: given, it reaches the resource. Omitted, the provider sends none and
# the platform derives it from the name — the provider's contract, pinned in
# its own suite; at plan the slug is unknown.
variables {
  nrn               = "organization=1:account=2"
  git_provider      = "local"
  local_specs_path  = "./tests/fixtures/svc"
  service_path      = "svc"
  service_name      = "AWS S3 Bucket"
  repository_branch = "v1.0.0"
  available_links   = ["connect"]
}

run "given_slugs_reach_the_service_and_link_specifications" {
  command = plan

  variables {
    service_slug = "np-aws-s3-bucket"
    link_slugs   = { connect = "np-s3-connect" }
  }

  assert {
    condition     = nullplatform_service_specification.from_template.slug == "np-aws-s3-bucket"
    error_message = "service_slug must be the service specification's slug"
  }

  assert {
    condition     = nullplatform_link_specification.from_templates["connect"].slug == "np-s3-connect"
    error_message = "link_slugs must reach the link specification keyed by its template name"
  }
}

run "a_slug_the_platform_could_not_derive_is_refused" {
  command = plan

  variables {
    service_slug = "AWS_S3"
  }

  expect_failures = [var.service_slug]
}

run "a_link_slug_the_platform_could_not_derive_is_refused" {
  command = plan

  variables {
    link_slugs = { connect = "s3--connect" }
  }

  expect_failures = [var.link_slugs]
}
