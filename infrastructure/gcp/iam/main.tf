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

# Workload Identity bindings
resource "google_service_account_iam_member" "workload_identity" {
  for_each = { for wi in var.workload_identity_bindings : "${wi.namespace}-${wi.ksa_name}" => wi }

  service_account_id = "projects/${var.project_id}/serviceAccounts/${each.value.service_account_email}"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value.namespace}/${each.value.ksa_name}]"
}
