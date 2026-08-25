# Service Accounts
resource "google_service_account" "sa" {
  for_each = { for sa in var.service_accounts : sa.name => sa }

  project      = var.project_id
  account_id   = each.value.name
  display_name = each.value.display_name
}

# IAM roles for Service Accounts
resource "google_project_iam_member" "sa_roles" {
  for_each = {
    for binding in flatten([
      for sa in var.service_accounts : [
        for role in sa.roles : {
          key  = "${sa.name}-${role}"
          sa   = sa.name
          role = role
        }
      ]
    ]) : binding.key => binding
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.sa[each.value.sa].email}"
}

# GCP's IAM API has a brief eventual-consistency lag after a service account
# is created: it can still return a 404 to IAM policy calls made moments
# later. Waiting here (in addition to the implicit depends_on below) avoids
# workload_identity bindings racing against service accounts created in the
# same apply.
resource "time_sleep" "wait_for_service_account_propagation" {
  count = length(var.workload_identity_bindings) > 0 ? 1 : 0

  depends_on      = [google_service_account.sa]
  create_duration = "15s"
}

# Workload Identity bindings
resource "google_service_account_iam_member" "workload_identity" {
  for_each = { for wi in var.workload_identity_bindings : "${wi.namespace}-${wi.ksa_name}" => wi }

  service_account_id = "projects/${var.project_id}/serviceAccounts/${each.value.service_account_email}"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value.namespace}/${each.value.ksa_name}]"

  depends_on = [time_sleep.wait_for_service_account_propagation]
}
