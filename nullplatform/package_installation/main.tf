################################################################################
# Package lookup
#
# The package is owned by its publisher, usually another organization that
# made it visible to every organization (visible_to organization=*), so it is
# found by where it is visible, not by its owner NRN. `version` resolves the
# exact revision this installation pins.
################################################################################
data "nullplatform_package" "this" {
  visible_at = var.nrn
  slug       = var.package_slug
  version    = var.package_version
}

################################################################################
# Installation
#
# New services and scopes under visible_to are born with default_revision_id.
# The installation does not follow the publisher's default afterwards: moving
# to another version is changing var.package_version.
################################################################################
resource "nullplatform_package_installation" "this" {
  nrn                 = var.nrn
  package_id          = data.nullplatform_package.this.id
  default_revision_id = data.nullplatform_package.this.revision_id
  visible_to          = var.visible_to
}

################################################################################
# Specification
#
# A service or scope package pins one specification. It belongs to the
# publisher and is readable at nrn only once the installation covers it. The
# id references the installation id instead of a depends_on: the id is unknown
# only while the installation is being created, so later plans (a version
# upgrade) read the specification at plan time.
################################################################################
data "nullplatform_service_specification" "this" {
  count = length(local.specification_ids) == 1 ? 1 : 0

  id = nullplatform_package_installation.this.id != "" ? one(local.specification_ids) : one(local.specification_ids)
}

################################################################################
# What the manifest creates on install
#
# A package's manifest may mark components "on": "install": what an
# organization needs once, such as a scope type or the form of the package's
# values. The installation above does not create them, and no provider
# resource runs a manifest, so this is `np package install` for the
# installation just made, a local-exec as the NRN settings of
# scope_package_installation are. The command finds the installation at nrn,
# keeps it on the same version, creates those components and records them on
# it, so running again updates and creates nothing twice.
#
# package_configuration needs them: make it depend on this module.
################################################################################
resource "terraform_data" "manifest" {
  count = var.apply_manifest ? 1 : 0

  triggers_replace = {
    installation_id = nullplatform_package_installation.this.id
    revision_id     = nullplatform_package_installation.this.default_revision_id
    imports         = var.manifest_imports
    package_dir     = var.package_dir
  }

  provisioner "local-exec" {
    command     = local.manifest_command
    environment = merge(local.manifest_environment, nonsensitive(var.np_api_key == null) ? {} : { NP_API_KEY = var.np_api_key })
  }
}
