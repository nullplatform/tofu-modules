locals {
  notification_channel_def = jsondecode(data.external.notification_channel.result.json)
  # Build overrides flag only when override feature is enabled
  overrides_flag = var.enabled_override ? "--overrides-path=${var.override_repo_path}${var.overrides_service_path}" : ""

  nrn_without_namespace = join(":", slice(split(":", var.nrn), 0, 2))

}