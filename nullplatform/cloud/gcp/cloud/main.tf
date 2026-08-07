resource "nullplatform_provider_config" "gcp" {
  nrn        = var.nrn
  type       = "google-cloud-configuration"
  dimensions = var.dimensions

  # `authentication` and `project.location` were dropped from this payload:
  # neither exists in the "google-cloud-configuration" provider specification
  # schema (authentication has no backing variable and was always sent empty;
  # project only declares `id`) — the API never persisted either back,
  # causing perpetual drift on every plan.
  attributes = jsonencode({
    "project" : {
      "id" : var.project_id
    },
    "networking" : {
      "domain_name" : var.domain_name,
      "application_domain" : var.application_domain,
      "public_dns_zone_name" : var.public_dns_zone_name,
      "private_dns_zone_name" : var.private_dns_zone_name
    }
  })
}
