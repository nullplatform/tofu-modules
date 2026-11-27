locals {
  # `np` takes a place and an agent as key=value pairs joined by commas.
  dimensions = join(",", [for key in sort(keys(var.dimensions)) : "${key}=${var.dimensions[key]}"])
  agent      = join(",", [for key in sort(keys(var.agent)) : "${key}=${var.agent[key]}"])

  # Everything given travels in the environment, so no value is ever part of
  # the shell command: a domain, an ARN or a JSON document needs no quoting.
  environment = {
    NP_PACKAGE_BIN        = var.np_bin
    NP_PACKAGE_NRN        = var.nrn
    NP_PACKAGE_SLUG       = var.package_slug
    NP_PACKAGE_DIMENSIONS = local.dimensions
    NP_PACKAGE_AGENT      = local.agent
    NP_PACKAGE_VALUES     = jsonencode(var.values)
    NP_PACKAGE_DIR        = var.package_dir == null ? "" : var.package_dir
  }

  # How the package's own tasks are treated, the same when the place is
  # configured and when it is removed.
  hook_flags = concat(
    var.package_dir == null ? [] : ["--dir \"$NP_PACKAGE_DIR\""],
    var.run_hooks ? [] : ["--no-hooks"],
  )

  flags = concat(
    ["--nrn \"$NP_PACKAGE_NRN\"", "--slug \"$NP_PACKAGE_SLUG\"", "--values \"$NP_PACKAGE_VALUES\""],
    local.dimensions == "" ? [] : ["--dimensions \"$NP_PACKAGE_DIMENSIONS\""],
    local.agent == "" ? [] : ["--agent \"$NP_PACKAGE_AGENT\""],
    local.hook_flags,
    [for name in sort(keys(var.imports)) : "--import ${name}=${var.imports[name]}"],
  )

  command = "\"$NP_PACKAGE_BIN\" package configure ${join(" ", local.flags)}"

  # Removing the place needs only what names it.
  remove_flags = concat(
    ["--nrn \"$NP_PACKAGE_NRN\"", "--slug \"$NP_PACKAGE_SLUG\""],
    local.dimensions == "" ? [] : ["--dimensions \"$NP_PACKAGE_DIMENSIONS\""],
    local.hook_flags,
  )

  remove_command = "\"$NP_PACKAGE_BIN\" package unconfigure ${join(" ", local.remove_flags)}"

  remove_environment = {
    NP_PACKAGE_BIN        = var.np_bin
    NP_PACKAGE_NRN        = var.nrn
    NP_PACKAGE_SLUG       = var.package_slug
    NP_PACKAGE_DIMENSIONS = local.dimensions
    NP_PACKAGE_DIR        = var.package_dir == null ? "" : var.package_dir
  }

  # What the place's configuration records, read back with `np package
  # status`: a jq filter that picks the place and answers flat text, as the
  # external data source takes it.
  record_query = join("", [
    "([.configurations[]? | select(.nrn == ", jsonencode(var.nrn),
    " and ((.dimensions // {}) == ", jsonencode(var.dimensions), "))] | first // {})",
    " | {status: (.status // \"not configured\"), version: (.version // \"\"), message: (.message // \"\"),",
    " outputs: ((.outputs // {}) | tojson), resources: ((.resources // []) | tojson)}",
  ])

  # The key, when one was given, reaches `np` through the environment and
  # never as an argument: it is read from what the data source writes on stdin.
  record_script = "key=$(sed -n 's/.*\"api_key\":\"\\([^\"]*\\)\".*/\\1/p'); if [ -n \"$key\" ]; then export NP_API_KEY=\"$key\"; fi; exec \"$4\" package status --nrn \"$1\" --slug \"$2\" --format json --query \"$3\""

  record = var.read_record ? data.external.record[0].result : null
}
