mock_provider "google" {}

variables {
  project_id = "myorg-project"
}

run "no_resources_with_empty_defaults" {
  command = plan
}

run "creates_service_accounts" {
  command = plan

  variables {
    service_accounts = [
      {
        name         = "cert-manager"
        display_name = "Cert Manager SA"
        roles        = ["roles/dns.admin"]
      },
      {
        name         = "external-dns"
        display_name = "External DNS SA"
        roles        = ["roles/dns.admin"]
      }
    ]
  }

  assert {
    condition     = google_service_account.sa["cert-manager"].account_id == "cert-manager"
    error_message = "SA account_id should match name"
  }

  assert {
    condition     = google_service_account.sa["external-dns"].account_id == "external-dns"
    error_message = "SA account_id should match name"
  }
}

run "workload_identity_binding_format" {
  command = plan

  variables {
    workload_identity_bindings = [
      {
        service_account_email = "cert-manager@myorg-project.iam.gserviceaccount.com"
        namespace             = "cert-manager"
        ksa_name              = "cert-manager"
      }
    ]
  }

  assert {
    condition     = google_service_account_iam_member.workload_identity["cert-manager-cert-manager"].role == "roles/iam.workloadIdentityUser"
    error_message = "WI binding should use workloadIdentityUser role"
  }

  assert {
    condition     = google_service_account_iam_member.workload_identity["cert-manager-cert-manager"].member == "serviceAccount:myorg-project.svc.id.goog[cert-manager/cert-manager]"
    error_message = "WI member should follow serviceAccount:{project}.svc.id.goog[{ns}/{ksa}] format"
  }
}

run "sa_with_multiple_roles" {
  command = plan

  variables {
    service_accounts = [
      {
        name         = "nullplatform-agent"
        display_name = "Nullplatform Agent"
        roles        = ["roles/dns.admin", "roles/container.viewer"]
      }
    ]
  }

  assert {
    condition     = google_project_iam_member.sa_roles["nullplatform-agent-roles/dns.admin"].role == "roles/dns.admin"
    error_message = "SA should have dns.admin role"
  }

  assert {
    condition     = google_project_iam_member.sa_roles["nullplatform-agent-roles/container.viewer"].role == "roles/container.viewer"
    error_message = "SA should have container.viewer role"
  }
}
