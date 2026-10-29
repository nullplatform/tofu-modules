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
