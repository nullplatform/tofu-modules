mock_provider "google" {
  mock_resource "google_service_account" {
    defaults = {
      email  = "mock-sa@myorg-project.iam.gserviceaccount.com"
      member = "serviceAccount:mock-sa@myorg-project.iam.gserviceaccount.com"
    }
  }
  mock_data "google_compute_zones" {
    defaults = {
      names = ["us-central1-a", "us-central1-b", "us-central1-c"]
    }
  }
  mock_data "google_container_engine_versions" {
    defaults = {
      latest_master_version = "1.30.5-gke.1443001"
      latest_node_version   = "1.30.5-gke.1443001"
      valid_master_versions = ["1.30.5-gke.1443001"]
      valid_node_versions   = ["1.30.5-gke.1443001"]
    }
  }
}
mock_provider "google-beta" {
  mock_resource "google_service_account" {
    defaults = {
      email  = "mock-sa@myorg-project.iam.gserviceaccount.com"
      member = "serviceAccount:mock-sa@myorg-project.iam.gserviceaccount.com"
    }
  }
  mock_data "google_compute_zones" {
    defaults = {
      names = ["us-central1-a", "us-central1-b", "us-central1-c"]
    }
  }
  mock_data "google_container_engine_versions" {
    defaults = {
      latest_master_version = "1.30.5-gke.1443001"
      latest_node_version   = "1.30.5-gke.1443001"
    }
  }
}
mock_provider "kubernetes" {}

variables {
  project_id        = "myorg-project"
  cluster_name      = "myorg-gke"
  location          = "us-central1"
  vpc_name          = "myorg-vpc"
  vpc_subnet_name   = "myorg-subnet"
  ip_range_pods     = "pods"
  ip_range_services = "services"
}

###############################################################################
# Mode selection
###############################################################################

run "standard_mode_by_default" {
  command = plan

  assert {
    condition     = length(module.gke) == 1 && length(module.gke_autopilot) == 0
    error_message = "autopilot_enabled defaults to false, so only the standard cluster should be planned"
  }
}

run "autopilot_mode_selects_the_other_module" {
  command = plan

  variables {
    autopilot_enabled = true
  }

  assert {
    condition     = length(module.gke) == 0 && length(module.gke_autopilot) == 1
    error_message = "autopilot_enabled should plan the Autopilot cluster and nothing else"
  }
}

###############################################################################
# node_pools: null stripping
#
# The wrapped module decides whether the caller opted into cluster-wide
# autoscaling with contains(keys(...)), not a null check, so a declared-but-unset
# optional attribute must not reach it.
###############################################################################

run "unset_total_counts_do_not_reach_the_wrapped_module" {
  command = plan

  assert {
    condition     = !contains(keys(local.node_pools[0]), "total_min_count")
    error_message = "An unset total_min_count must be stripped: the wrapped module reads contains(keys(...)) and would null out the per-zone autoscaling bounds for every pool"
  }

  assert {
    condition     = !contains(keys(local.node_pools[0]), "total_max_count")
    error_message = "An unset total_max_count must be stripped for the same reason"
  }

  assert {
    condition     = local.node_pools[0]["min_count"] == 1
    error_message = "Attributes that do have a default must survive the stripping"
  }
}

run "set_total_counts_do_reach_the_wrapped_module" {
  command = plan

  variables {
    node_pools = [{
      name            = "pool-wide"
      total_min_count = 3
      total_max_count = 9
    }]
  }

  assert {
    condition     = local.node_pools[0]["total_min_count"] == 3 && local.node_pools[0]["total_max_count"] == 9
    error_message = "Explicit total counts must be passed through"
  }
}

run "total_counts_must_be_set_together" {
  command = plan

  variables {
    node_pools = [{
      name            = "pool-half"
      total_min_count = 3
    }]
  }

  expect_failures = [var.node_pools]
}

###############################################################################
# node_pools: spot and preemptible
###############################################################################

run "spot_and_preemptible_together_is_rejected" {
  command = plan

  variables {
    node_pools = [{
      name        = "pool-both"
      spot        = true
      preemptible = true
    }]
  }

  expect_failures = [var.node_pools]
}

run "spot_alone_is_accepted" {
  command = plan

  variables {
    node_pools = [{
      name = "pool-spot"
      spot = true
    }]
  }

  assert {
    condition     = local.node_pools[0]["spot"] == true
    error_message = "A pool may set spot on its own"
  }
}

run "preemptible_alone_is_accepted" {
  command = plan

  variables {
    node_pools = [{
      name        = "pool-preempt"
      preemptible = true
    }]
  }

  assert {
    condition     = local.node_pools[0]["preemptible"] == true
    error_message = "A pool may set preemptible on its own"
  }
}

run "mixed_on_demand_and_spot_pools_plan" {
  command = plan

  variables {
    node_pools = [
      {
        name        = "pool-default"
        node_count  = 1
        autoscaling = false
      },
      {
        name      = "pool-spot"
        spot      = true
        min_count = 0
        max_count = 2
      },
    ]
  }

  assert {
    condition     = length(local.node_pools) == 2
    error_message = "Both pools should be passed through"
  }
}

###############################################################################
# node_pools_taints
###############################################################################

run "no_taints_by_default" {
  command = plan

  assert {
    condition     = length(var.node_pools_taints) == 0
    error_message = "node_pools_taints should default to empty so existing pools are untouched"
  }
}

run "spot_pool_can_be_tainted" {
  command = plan

  variables {
    node_pools = [{
      name = "pool-spot"
      spot = true
    }]
    node_pools_taints = {
      pool-spot = [{
        key    = "cloud.google.com/gke-spot"
        value  = "true"
        effect = "NO_SCHEDULE"
      }]
    }
  }

  assert {
    condition     = var.node_pools_taints["pool-spot"][0].effect == "NO_SCHEDULE"
    error_message = "Taints must be expressible per pool, so workloads can be kept off preemptible capacity"
  }
}

###############################################################################
# Outputs resolve in both modes
###############################################################################

run "outputs_resolve_in_standard_mode" {
  command = apply

  assert {
    condition     = output.cluster_name != null && output.cluster_name != ""
    error_message = "cluster_name must resolve from the standard module when autopilot is off, not index a zero-count module"
  }
}

run "outputs_resolve_in_autopilot_mode" {
  command = apply

  variables {
    autopilot_enabled = true
  }

  assert {
    condition     = output.cluster_name != null && output.cluster_name != ""
    error_message = "cluster_name must resolve from the Autopilot module when autopilot is on, not index a zero-count module"
  }
}
