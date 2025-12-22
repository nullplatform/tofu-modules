resource "nullplatform_provider_config" "gcp" {
  nrn        = var.nrn
  type       = "google-cloud-configuration"
  dimensions = var.dimensions

  attributes = jsonencode({
    "authentication" : {},
    "project" : {
      "id" : var.project_id
      "location" : var.location
    },
    "networking" : {
      "domain_name" : var.domain_name,
      "application_domain" : var.application_domain,
      "public_dns_zone_name" : var.public_dns_zone_name,
      "private_dns_zone_name" : var.private_dns_zone_name
    }
  })

  lifecycle {
    ignore_changes = [attributes]
  }
}
