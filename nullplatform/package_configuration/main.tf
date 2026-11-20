################################################################################
# Configuration of an installed package for one place
#
# A package is installed once in an organization and configured once per
# place: an NRN and, usually, dimensions (environment = production). A
# configuration names the agent that serves the place and gives the package's
# values there.
#
# What it creates is written in the package's own manifest: the components
# marked "on": "configure", such as the values and the channel to the agent.
# So this module knows no kind of package. It runs the command that reads that
# manifest, `np package configure`, the same one a person runs.
#
# Two places that share a cluster and its agent are two calls with the same
# `agent` (a for_each): each gets its own values and its own channel.
#
# No provider resource runs a package's manifest, so this is a local-exec, as
# the NRN settings of scope_package_installation are. It follows that:
#   - the machine running the apply needs `np`, a version that has `package
#     configure`, and credentials: NP_API_KEY in its environment or np_api_key;
#   - what the command creates is not in the state. The installation records
#     it (`np package status`) and the command finds it there on the next run,
#     so running again updates and creates nothing twice;
#   - destroying the configuration removes it from the state only. `np` has no
#     command to remove a place yet.
################################################################################
resource "terraform_data" "this" {
  triggers_replace = {
    nrn             = var.nrn
    package_slug    = var.package_slug
    package_version = var.package_version
    dimensions      = var.dimensions
    agent           = var.agent
    values          = var.values
    imports         = var.imports
    package_dir     = var.package_dir
  }

  # Whether a key was given is not a secret, the key is. With none given the
  # environment holds nothing sensitive and the apply shows what the command
  # did; with one given OpenTofu hides the command's output to protect it.
  provisioner "local-exec" {
    command     = local.command
    environment = merge(local.environment, nonsensitive(var.np_api_key == null) ? {} : { NP_API_KEY = var.np_api_key })
  }
}
