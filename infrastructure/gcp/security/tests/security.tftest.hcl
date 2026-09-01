mock_provider "google" {}

variables {
  cluster_name   = "myorg-cluster"
  gcp_project_id = "myorg-project"
  gcp_region     = "us-central1"
}

###############################################################################
# Subnetwork reference parsing
#
# The GKE API always returns a relative resource path, so that is the shape that
# matters. The other two are covered so a later "simplification" to a fixed index
# or basename() cannot pass silently.
###############################################################################

run "relative_resource_path_yields_name_region_and_project" {
  command = plan

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "projects/host-project/regions/europe-west4/subnetworks/subnet-gke"
      network    = "myorg-vpc"
    }
  }

  assert {
    condition     = local.cluster_subnetwork_name == "subnet-gke"
    error_message = "Should extract the bare subnetwork name from a full resource path"
  }

  # These two are the point of the change: the path names a project and region that
  # differ from the configured ones, and resolving the subnetwork against the
  # configured pair would 404.
  assert {
    condition     = local.cluster_subnetwork_region == "europe-west4"
    error_message = "The region from the resource path must win over gcp_region, or a zonal cluster (whose gcp_region is a zone) and a cross-region subnet both 404"
  }

  assert {
    condition     = local.cluster_subnetwork_project == "host-project"
    error_message = "The project from the resource path must win over gcp_project_id, or a Shared VPC subnet in the host project 404s"
  }
}

run "self_link_is_parsed_too" {
  command = plan

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "https://www.googleapis.com/compute/v1/projects/host-project/regions/europe-west4/subnetworks/subnet-gke"
      network    = "myorg-vpc"
    }
  }

  assert {
    condition     = local.cluster_subnetwork_name == "subnet-gke"
    error_message = "A self_link must parse to the same name"
  }

  assert {
    condition     = local.cluster_subnetwork_region == "europe-west4" && local.cluster_subnetwork_project == "host-project"
    error_message = "A self_link must yield the same region and project as the relative path"
  }
}

run "bare_name_falls_back_to_the_configured_project_and_region" {
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
    error_message = "A bare subnetwork name must pass through unchanged"
  }

  assert {
    condition     = local.cluster_subnetwork_region == "us-central1" && local.cluster_subnetwork_project == "myorg-project"
    error_message = "With no path to parse, the configured region and project must be used"
  }
}

###############################################################################
# Firewall wiring
#
# Asserting on counts alone is vacuous: they depend only on the enable flags, so
# reverting the parse leaves them green. These assert the values the derivation
# actually produces.
###############################################################################

run "public_health_check_allows_the_subnet_cidr_and_gcp_probes" {
  command = plan

  variables {
    gateways_enabled         = true
    gateway_internal_enabled = true
  }

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "projects/myorg-project/regions/us-central1/subnetworks/subnet-gke"
      network    = "projects/myorg-project/global/networks/myorg-vpc"
    }
  }

  override_data {
    target = data.google_compute_subnetwork.this
    values = {
      ip_cidr_range = "10.20.0.0/20"
    }
  }

  assert {
    condition     = google_compute_firewall.public_gateway_health_check[0].source_ranges == toset(["10.20.0.0/20", "35.191.0.0/16", "130.211.0.0/22"])
    error_message = "The health-check rule must allow the derived subnet CIDR plus both GCP health check ranges"
  }

  assert {
    condition     = google_compute_firewall.private_gateway_https[0].source_ranges == toset(["10.20.0.0/20"])
    error_message = "The private HTTPS rule must be restricted to the derived subnet CIDR"
  }

  # The network value is deliberately NOT parsed: google_compute_firewall.network
  # runs it through ParseGlobalFieldValue, so a full path is valid there.
  assert {
    condition     = google_compute_firewall.public_gateway_https[0].network == "projects/myorg-project/global/networks/myorg-vpc"
    error_message = "The network reference must pass through unparsed"
  }

  assert {
    condition     = length(google_compute_firewall.public_gateway_https) == 1 && length(google_compute_firewall.private_gateway_https) == 1
    error_message = "Both gateways' rules should be created when both flags are true"
  }
}

run "gateways_can_be_disabled_independently" {
  command = plan

  variables {
    gateways_enabled         = false
    gateway_internal_enabled = true
  }

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "projects/myorg-project/regions/us-central1/subnetworks/subnet-gke"
      network    = "myorg-vpc"
    }
  }

  assert {
    condition     = length(google_compute_firewall.public_gateway_https) == 0 && length(google_compute_firewall.private_gateway_https) == 1
    error_message = "gateways_enabled must gate only the public rules"
  }
}

###############################################################################
# Overrides
###############################################################################

run "network_cidr_override_wins_and_skips_the_subnetwork_lookup" {
  command = plan

  variables {
    gateway_internal_enabled = true
    network_cidr             = "192.168.0.0/24"
  }

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "projects/myorg-project/regions/us-central1/subnetworks/subnet-gke"
      network    = "myorg-vpc"
    }
  }

  assert {
    condition     = local.effective_network_cidr == "192.168.0.0/24"
    error_message = "An explicit network_cidr must win over the derived value"
  }

  assert {
    condition     = length(data.google_compute_subnetwork.this) == 0
    error_message = "With network_cidr supplied there is nothing to derive, so the subnetwork lookup must be skipped rather than requiring compute.subnetworks.get"
  }
}

run "both_overrides_skip_the_cluster_lookup_entirely" {
  command = plan

  variables {
    gateways_enabled         = true
    gateway_internal_enabled = true
    gcp_network_name         = "myorg-vpc"
    network_cidr             = "192.168.0.0/24"
  }

  assert {
    condition     = length(data.google_container_cluster.this) == 0 && length(data.google_compute_subnetwork.this) == 0
    error_message = "With both values supplied the module must not read the cluster at all, so it does not need container.clusters.get"
  }

  assert {
    condition     = google_compute_firewall.private_gateway_https[0].source_ranges == toset(["192.168.0.0/24"])
    error_message = "The rules must still be built from the supplied values"
  }
}

run "gcp_network_name_override_wins" {
  command = plan

  variables {
    gateways_enabled = true
    gcp_network_name = "override-vpc"
  }

  override_data {
    target = data.google_container_cluster.this
    values = {
      subnetwork = "projects/myorg-project/regions/us-central1/subnetworks/subnet-gke"
      network    = "derived-vpc"
    }
  }

  assert {
    condition     = google_compute_firewall.public_gateway_https[0].network == "override-vpc"
    error_message = "An explicit gcp_network_name must win over the derived network"
  }
}
