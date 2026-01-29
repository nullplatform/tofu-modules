locals {
  notification_channel_def = jsondecode(data.external.notification_channel.result.json)
  # Build overrides flag only when override feature is enabled
  overrides_flag = var.enabled_override ? "--overrides-path=${var.override_repo_path}${var.overrides_service_path}" : ""

  nrn_without_namespace = join(":", slice(split(":", var.nrn), 0, 2))

  # Parse NRN parts into individual tags: "organization=123:account=456:namespace=789"
  nrn_parts = { for part in split(":", var.nrn) : split("=", part)[0] => split("=", part)[1] }
  nrn_tags = [
    for key in ["organization", "account", "namespace"] : {
      key   = key
      value = local.nrn_parts[key]
    } if contains(keys(local.nrn_parts), key)
  ]
}