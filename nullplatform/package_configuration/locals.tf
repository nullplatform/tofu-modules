locals {
  # `np` takes a place and an agent as key=value pairs joined by commas.
  dimensions = join(",", [for key in sort(keys(var.dimensions)) : "${key}=${var.dimensions[key]}"])
  agent      = join(",", [for key in sort(keys(var.agent)) : "${key}=${var.agent[key]}"])

  # Everything given travels in the environment, so no value is ever part of
  # the shell command: a domain, an ARN or a JSON document needs no quoting.
  environment = {
    NP_PACKAGE_NRN        = var.nrn
    NP_PACKAGE_SLUG       = var.package_slug
    NP_PACKAGE_DIMENSIONS = local.dimensions
    NP_PACKAGE_AGENT      = local.agent
    NP_PACKAGE_VALUES     = jsonencode(var.values)
    NP_PACKAGE_DIR        = var.package_dir == null ? "" : var.package_dir
  }

  flags = concat(
    ["--nrn \"$NP_PACKAGE_NRN\"", "--slug \"$NP_PACKAGE_SLUG\"", "--values \"$NP_PACKAGE_VALUES\""],
    local.dimensions == "" ? [] : ["--dimensions \"$NP_PACKAGE_DIMENSIONS\""],
    local.agent == "" ? [] : ["--agent \"$NP_PACKAGE_AGENT\""],
    var.package_dir == null ? ["--no-hooks"] : ["--dir \"$NP_PACKAGE_DIR\""],
    [for name in sort(keys(var.imports)) : "--import ${name}=${var.imports[name]}"],
  )

  command = "np package configure ${join(" ", local.flags)}"
}
