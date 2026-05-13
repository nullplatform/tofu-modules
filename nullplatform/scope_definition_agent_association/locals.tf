locals {
  notification_channel_def = jsondecode(data.external.notification_channel.result.json)
  # Build overrides flag only when override feature is enabled
  overrides_flag = var.enabled_override ? "--overrides-path=${var.override_repo_path}${var.overrides_service_path}" : ""

  base_filters = can(local.notification_channel_def.filters) ? local.notification_channel_def.filters : null

  # If extra_filters provided, wrap base filters and extra conditions under $and
  merged_filters = length(var.extra_filters) > 0 && local.base_filters != null ? {
    "$and" = concat([local.base_filters], var.extra_filters)
  } : local.base_filters
}
