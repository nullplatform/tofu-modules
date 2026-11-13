################################################################################
# Publication of a scope as a package
#
# The release contract between a scope repository and the platform, in one
# place: the revision's version is the release tag (the version the worker
# image was registered with), a stable release becomes the package default and
# a prerelease does not, the image is pinned by digest, and the templates come
# from the checkout being published. The release workflow applies a stack built
# on this module at the release tag with the digest it pushed
# (actions-nullplatform publish-package); organizations install the result
# with scope_package_installation.
#
# Only what the package pins is created in the publisher organization: the
# scope specification and its actions. The scope type, the NRN settings and
# the scope-configuration schema belong to each organization that installs the
# package, which creates them from the same templates.
################################################################################
locals {
  version    = trimprefix(var.release_tag, "v")
  prerelease = length(regexall("-", local.version)) > 0

  # Whether this revision becomes the package default. A stable release
  # promotes; a prerelease is published without moving the default, so it can be
  # installed by version to try it. promote_default forces either.
  promote_default = var.promote_default != null ? var.promote_default : !local.prerelease
}

module "scope_definition" {
  source = "../scope_definition"

  nrn = var.nrn

  # Templates come from the checkout, so the package pins exactly the specs of
  # its release.
  local_specs_path = var.local_specs_path
  service_path     = var.service_path

  # The name is what people read; the slug carries the namespace and is what
  # an installation's channel filter and NRN settings use.
  service_spec_name        = var.service_spec_name
  service_spec_slug        = coalesce(var.service_spec_slug, var.package_slug)
  service_spec_description = var.service_spec_description
  action_spec_names        = var.action_spec_names

  # Each installing organization creates these (scope_package_installation),
  # and without the NRN patch the apply needs no `np`.
  create_scope_type          = false
  configure_nrn_settings     = false
  create_scope_configuration = false

  package = {
    slug       = var.package_slug
    version    = local.version
    default    = local.promote_default
    visible_to = var.visible_to
    artifacts = [{
      name   = var.artifact_name
      type   = "oci_image"
      lookup = true # registered by the release workflow before this runs
      meta = {
        registry   = var.image_registry
        repository = var.image_repository
        digest     = var.image_digest
      }
    }]
  }
}
