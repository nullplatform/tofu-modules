mock_provider "nullplatform" {}

variables {
  dimension_id = 12345
  name         = "OCI"
}

run "creates_one_value_when_using_single_nrn" {
  command = plan

  variables {
    nrn = "organization=1698562351:account=1372325109:namespace=956240080"
  }

  assert {
    condition     = length(nullplatform_dimension_value.this) == 1
    error_message = "Should create exactly one dimension_value when using var.nrn"
  }

  assert {
    condition     = nullplatform_dimension_value.this["organization=1698562351:account=1372325109:namespace=956240080"].name == "OCI"
    error_message = "Dimension value name should match var.name"
  }

  assert {
    condition     = nullplatform_dimension_value.this["organization=1698562351:account=1372325109:namespace=956240080"].dimension_id == 12345
    error_message = "Dimension value should reference the parent dimension_id"
  }
}

run "creates_multiple_values_when_using_nrns_list" {
  command = plan

  variables {
    nrns = [
      "organization=1698562351:account=1372325109:namespace=956240080",
      "organization=1698562351:account=1372325109:namespace=999999999",
    ]
  }

  assert {
    condition     = length(nullplatform_dimension_value.this) == 2
    error_message = "Should create one dimension_value per NRN in var.nrns"
  }
}

run "fails_when_both_nrn_and_nrns_are_set" {
  command = plan

  variables {
    nrn  = "organization=1698562351:account=1372325109:namespace=956240080"
    nrns = ["organization=1698562351:account=1372325109:namespace=999999999"]
  }

  expect_failures = [
    resource.terraform_data.validation,
  ]
}

run "fails_when_neither_nrn_nor_nrns_is_set" {
  command = plan

  expect_failures = [
    resource.terraform_data.validation,
  ]
}
