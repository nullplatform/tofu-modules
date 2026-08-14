mock_provider "google" {}

variables {
  cluster_name   = "myorg-cluster"
  gcp_project_id = "myorg-project"
  gcp_region     = "us-central1"
}

run "subnetwork_name_extracted_from_full_resource_path" {
  command = plan

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "projects/myorg-project/regions/us-central1/subnetworks/subnet-gke"
      network    = "myorg-vpc"
    }
  }

  assert {
    condition     = local.cluster_subnetwork_name == "subnet-gke"
    error_message = "Should extract the bare subnetwork name when the cluster's subnetwork attribute is a full resource path"
  }
}

run "subnetwork_name_passthrough_when_already_bare" {
  command = plan

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "subnet-gke"
      network    = "myorg-vpc"
    }
  }

  assert {
    condition     = local.cluster_subnetwork_name == "subnet-gke"
    error_message = "Should pass through an already-bare subnetwork name unchanged"
  }
}

run "firewall_rules_created_for_both_gateways" {
  command = plan

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "projects/myorg-project/regions/us-central1/subnetworks/subnet-gke"
      network    = "myorg-vpc"
    }
  }

  variables {
    gateways_enabled         = true
    gateway_internal_enabled = true
  }

  assert {
    condition     = length(google_compute_firewall.public_gateway_https) == 1
    error_message = "Public HTTPS firewall rule should be created when gateways_enabled is true"
  }

  assert {
    condition     = length(google_compute_firewall.private_gateway_https) == 1
    error_message = "Private HTTPS firewall rule should be created when gateway_internal_enabled is true"
  }
}
