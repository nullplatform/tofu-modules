terraform {
  required_version = ">= 1.5"

  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # 0.0.98 is the first release exposing `last_snapshot_id` +
      # `action_specifications` on service/link specifications (used to pin the
      # BOM) — see nullplatform/terraform-provider-nullplatform#149.
      version = ">= 0.0.98"
    }
  }
}
