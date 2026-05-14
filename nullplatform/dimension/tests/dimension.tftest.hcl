mock_provider "nullplatform" {
  override_resource {
    target = nullplatform_dimension.this
    values = {
      id = 1001
    }
  }
}

variables {
  nrn  = "organization=myorg:account=myaccount"
  name = "Environment"
}

run "creates_dimension_with_given_name_and_default_order" {
  command = plan

  assert {
    condition     = nullplatform_dimension.this.name == "Environment"
    error_message = "Dimension name should match var.name"
  }

  assert {
    condition     = nullplatform_dimension.this.order == 1
    error_message = "Dimension order should default to 1"
  }

  assert {
    condition     = nullplatform_dimension.this.nrn == "organization=myorg:account=myaccount"
    error_message = "Dimension NRN should match input"
  }
}

run "creates_dimension_with_custom_name_and_order" {
  command = plan

  variables {
    name  = "Region"
    order = 2
  }

  assert {
    condition     = nullplatform_dimension.this.name == "Region"
    error_message = "Dimension name should match var.name"
  }

  assert {
    condition     = nullplatform_dimension.this.order == 2
    error_message = "Dimension order should match var.order"
  }
}

run "creates_no_values_when_list_is_empty" {
  command = plan

  assert {
    condition     = length(nullplatform_dimension_value.this) == 0
    error_message = "No dimension values should be created when var.values is empty"
  }
}

run "creates_a_value_per_entry" {
  command = plan

  variables {
    values = ["development", "staging", "production"]
  }

  assert {
    condition     = nullplatform_dimension_value.this["development"].name == "development"
    error_message = "Should create development value"
  }

  assert {
    condition     = nullplatform_dimension_value.this["staging"].name == "staging"
    error_message = "Should create staging value"
  }

  assert {
    condition     = nullplatform_dimension_value.this["production"].name == "production"
    error_message = "Should create production value"
  }
}
