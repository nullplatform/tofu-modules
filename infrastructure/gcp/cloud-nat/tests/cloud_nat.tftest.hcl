mock_provider "google" {}

variables {
  project_id  = "myorg-project"
  region      = "us-central1"
  network_id  = "projects/myorg-project/global/networks/myorg-vpc"
  router_name = "myorg-router"
  nat_name    = "myorg-nat"
}

run "nat_auto_ip_allocation" {
  command = plan

  assert {
    condition     = google_compute_router_nat.nat.nat_ip_allocate_option == "AUTO_ONLY"
    error_message = "NAT should use AUTO_ONLY IP allocation"
  }
}

run "nat_all_subnets" {
  command = plan

  assert {
    condition     = google_compute_router_nat.nat.source_subnetwork_ip_ranges_to_nat == "ALL_SUBNETWORKS_ALL_IP_RANGES"
    error_message = "NAT should cover all subnets and IP ranges"
  }
}

run "router_config" {
  command = plan

  assert {
    condition     = google_compute_router.router.name == "myorg-router"
    error_message = "Router name should match variable"
  }

  assert {
    condition     = google_compute_router.router.region == "us-central1"
    error_message = "Router region should match variable"
  }
}

run "nat_references_router" {
  command = plan

  assert {
    condition     = google_compute_router_nat.nat.router == google_compute_router.router.name
    error_message = "NAT should reference the router by name"
  }
}
