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
    nrn                    = "organization=1"
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
