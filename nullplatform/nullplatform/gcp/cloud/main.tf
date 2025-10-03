

resource "nullplatform_provider_config" "gcp" {
  nrn        = var.nrn
  type       = "google-cloud-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    "project" : {
      "id" : var.project_id
      "location" : var.location
    },
    "networking" : {
      "domain_name" : var.domain_name,
      "application_domain" : false
    },

  })
}


resource "nullplatform_dimension" "environment" {
  name  = "Environment"
  order = 1
  nrn   = var.nrn
}

resource "nullplatform_dimension_value" "environment_value" {
  for_each     = toset(var.environments)
  dimension_id = nullplatform_dimension.environment.id
  name         = each.value
  nrn          = var.nrn
}
