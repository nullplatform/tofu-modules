locals {
  # `np package install` for this installation. What is given travels in the
  # environment, so it is never part of the shell command.
  manifest_environment = {
    NP_PACKAGE_NRN     = var.nrn
    NP_PACKAGE_SLUG    = var.package_slug
    NP_PACKAGE_VERSION = var.package_version
    NP_PACKAGE_DIR     = var.package_dir == null ? "" : var.package_dir
  }

  manifest_command = join(" ", concat(
    ["np package install --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --version \"$NP_PACKAGE_VERSION\""],
    var.package_dir == null ? ["--no-hooks"] : ["--dir \"$NP_PACKAGE_DIR\""],
    [for name in sort(keys(var.manifest_imports)) : "--import ${name}=${var.manifest_imports[name]}"],
  ))

  specification_ids = [
    for component in data.nullplatform_package.this.components : component.resource_id
    if component.resource_type == "service_specification"
  ]
}
