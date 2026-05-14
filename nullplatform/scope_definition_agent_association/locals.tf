locals {
  notification_channel_def = jsondecode(data.external.notification_channel.result.json)
  # Build overrides flag only when override feature is enabled
  overrides_flag = var.enabled_override ? "--overrides-path=${var.override_repo_path}${var.overrides_service_path}" : ""

  base_filters = can(local.notification_channel_def.filters) ? local.notification_channel_def.filters : null

  # Produce a JSON string to avoid Terraform's object-shape type-consistency constraint.
  # If extra_filters are provided, wrap base filters and the extra expression under $and; otherwise pass base as-is.
  merged_filters_json = (
    local.base_filters == null ? null :
    var.extra_filters != null
    ? jsonencode({ "$and" = [local.base_filters, var.extra_filters] })
    : jsonencode(local.base_filters)
  )
}
