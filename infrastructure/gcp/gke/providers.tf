terraform {
  required_version = ">= 1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    # The Autopilot path creates its cluster with `provider = google-beta`
    # (beta-autopilot-private-cluster/cluster.tf:23). Provider requirements are
    # static — count = 0 does not suppress them — so this must be declared and
    # constrained to the same major as google, or a fresh init resolves an
    # unpinned google-beta and the root's provider credentials never reach it.
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}
