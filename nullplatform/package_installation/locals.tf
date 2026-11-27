locals {
  # `np package install` for this installation. What is given travels in the
  # environment, so it is never part of the shell command.
  manifest_environment = {
    NP_PACKAGE_BIN     = var.np_bin
    NP_PACKAGE_NRN     = var.nrn
    NP_PACKAGE_SLUG    = var.package_slug
    NP_PACKAGE_VERSION = var.package_version
    NP_PACKAGE_DIR     = var.package_dir == null ? "" : var.package_dir
  }

  # How the package's own tasks are treated, the same when the manifest is
  # applied and when what it created is removed.
  manifest_hook_flags = concat(
    var.package_dir == null ? [] : ["--dir \"$NP_PACKAGE_DIR\""],
    var.run_hooks ? [] : ["--no-hooks"],
  )

  manifest_command = join(" ", concat(
    ["\"$NP_PACKAGE_BIN\" package install --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --version \"$NP_PACKAGE_VERSION\""],
    local.manifest_hook_flags,
    [for name in sort(keys(var.manifest_imports)) : "--import ${name}=${var.manifest_imports[name]}"],
  ))

  # Removing what the manifest created leaves the installation itself to the
  # resource that made it.
  manifest_remove_command = join(" ", concat(
    ["\"$NP_PACKAGE_BIN\" package uninstall --nrn \"$NP_PACKAGE_NRN\" --slug \"$NP_PACKAGE_SLUG\" --keep-installation"],
    local.manifest_hook_flags,
  ))

  manifest_remove_environment = {
    NP_PACKAGE_BIN  = var.np_bin
    NP_PACKAGE_NRN  = var.nrn
    NP_PACKAGE_SLUG = var.package_slug
    NP_PACKAGE_DIR  = var.package_dir == null ? "" : var.package_dir
  }

  specification_ids = [
    for component in data.nullplatform_package.this.components : component.resource_id
    if component.resource_type == "service_specification"
  ]
}
