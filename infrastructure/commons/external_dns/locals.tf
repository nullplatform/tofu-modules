locals {
  external_dns_values = templatefile("${path.module}/templates/external_dns_values.tmpl.yaml", {
    domain       = var.domain
    txt_owner_id = var.txt_owner_id
    provider     = var.dns_provider_name
    extra_args   = var.extra_args
    ksa_name     = var.ksa_name
    gsa_email    = google_service_account.external_dns.email

  })
  create_cf_secret = lower(var.dns_provider_name) == "cloudflare"
}