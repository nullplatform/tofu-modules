terraform {
  required_version = ">= 1.5"

  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # Needs a provider that exposes `last_snapshot_id` + `action_specifications`
      # on service/link specifications (used to pin the BOM).
      version = ">= 0.0.90"
    }
  }
}
