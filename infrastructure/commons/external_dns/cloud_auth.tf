# GSA
resource "google_service_account" "external_dns" {
  for_each     = local.google_toggle
  account_id   = var.gsa_name
  display_name = "ExternalDNS GSA"
  project      = var.project_id
}

# Permission Cloud DNS
resource "google_project_iam_member" "external_dns_dns_admin" {
  for_each   = local.google_toggle
  project    = var.project_id
  role       = "roles/dns.admin"
  member     = "serviceAccount:${google_service_account.external_dns["on"].email}"
  depends_on = [google_service_account.external_dns]
}

# Workload Identity binding KSA -> GSA
resource "google_service_account_iam_member" "wi_binding" {
  for_each           = local.google_toggle
  service_account_id = google_service_account.external_dns["on"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.external_dns_namespace}/${var.ksa_name}]"
  depends_on         = [google_project_iam_member.external_dns_dns_admin]
}
