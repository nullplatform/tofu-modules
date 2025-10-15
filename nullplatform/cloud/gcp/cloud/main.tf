

resource "nullplatform_provider_config" "gcp" {
  nrn        = var.nrn
  type       = "google-cloud-configuration"
  dimensions = {}
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


