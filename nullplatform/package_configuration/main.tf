################################################################################
# Configuration of an installed package for one place
#
# A package is installed once in an organization and configured once per
# place: an NRN and, usually, dimensions (environment = production). A
# configuration names the agent that serves the place and gives the package's
# values there.
#
# What it creates is written in the package's own manifest: the components
# marked "on": "configure", such as the values and the channel to the agent,
# each made by its kind's API or by a task of the package. So this module knows
# no kind of package. It runs the command that reads that manifest, `np package
# configure`, the same one a person runs.
#
# Two places that share a cluster and its agent are two calls with the same
# `agent` (a for_each): each gets its own values and its own channel.
#
# No provider resource runs a package's manifest, so this is a local-exec, as
# the NRN settings of scope_package_installation are. It follows that:
#   - the machine running the apply needs `np`, a version that has `package
#     configure`, and credentials: NP_API_KEY in its environment or np_api_key.
#     A package with tasks of its own also needs `mise`, which installs the
#     tools those tasks declare, and `git` with read access to the package's
#     repository: its tasks run the source the version pins. No Docker;
#   - what the command creates is not in the state. The place's configuration
#     records it (`np package status`) and the command finds it there on the next run,
#     so running again updates and creates nothing twice. The outputs of this
#     module are read back from that record;
#   - destroying the configuration removes the place: `np package unconfigure`
#     removes what configuring created there and leaves what it only used.
################################################################################

# The place itself: what names it, and what removes it. Changing what the
# package gets there (values, agent, version) does not replace it, so the
# place is never removed and made again for a new value.
resource "terraform_data" "place" {
  triggers_replace = {
    nrn          = var.nrn
    package_slug = var.package_slug
    dimensions   = var.dimensions
  }

  # A destroy-time provisioner reads only the resource itself.
  input = {
    command     = local.remove_command
    environment = local.remove_environment
    np_api_key  = var.np_api_key
  }

  provisioner "local-exec" {
    when        = destroy
    command     = self.input.command
    environment = merge(self.input.environment, nonsensitive(self.input.np_api_key == null) ? {} : { NP_API_KEY = self.input.np_api_key })
  }
}

# What the package gets at the place. Any change runs the command again,
# which updates what the place already has.
resource "terraform_data" "this" {
  triggers_replace = {
    place           = terraform_data.place.id
    package_version = var.package_version
    agent           = var.agent
    values          = var.values
    imports         = var.imports
    package_dir     = var.package_dir
    run_hooks       = var.run_hooks
  }

  # Whether a key was given is not a secret, the key is. With none given the
  # environment holds nothing sensitive and the apply shows what the command
  # did; with one given OpenTofu hides the command's output to protect it.
  provisioner "local-exec" {
    command     = local.command
    environment = merge(local.environment, nonsensitive(var.np_api_key == null) ? {} : { NP_API_KEY = var.np_api_key })
  }
}

################################################################################
# What the place's configuration records
#
# The ids of what was created and what the package's tasks answered are on
# the installation, not in the state. They are read back after the command
# ran, and on every later plan, with `np package status`.
################################################################################
data "external" "record" {
  count = var.read_record ? 1 : 0

  program = ["sh", "-c", local.record_script, "np-package-record", var.nrn, var.package_slug, local.record_query, var.np_bin]
  query   = var.np_api_key == null ? {} : { api_key = var.np_api_key }

  depends_on = [terraform_data.this]
}
