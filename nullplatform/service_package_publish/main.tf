################################################################################
# Publication of a service as a package
#
# The release contract between a service repository and the platform, in one
# place: the revision's version is the release tag (the version the worker
# image was registered with), a stable release becomes the package default and
# a prerelease does not, the image is pinned by digest, and the specs come from
# the checkout being published. The release workflow applies a stack built on
# this module at the release tag with the digest it pushed (actions-nullplatform
# publish-package); organizations install the result with
# service_package_installation.
#
# Each apply publishes one immutable revision that pins the service
# specification, its link specifications, every action specification
# (templates and platform defaults alike) and the image. Re-applying the same
# version is a no-op.
################################################################################
locals {
  version    = trimprefix(var.release_tag, "v")
  prerelease = length(regexall("-", local.version)) > 0

  # Whether this revision becomes the package default. A stable release
  # promotes; a prerelease is published without moving the default, so it can be
  # installed by version to try it. promote_default forces either.
  promote_default = var.promote_default != null ? var.promote_default : !local.prerelease
}

module "service_definition" {
  source = "../service_definition"

  nrn = var.nrn

  # Specs come from the checkout, not from a raw repository URL, so a release
  # publishes exactly the specs of its own tag. repository_branch is required
  # by the module but not read with git_provider = "local"; the tag keeps the
  # stack saying which specs it published.
  git_provider      = "local"
  local_specs_path  = var.local_specs_path
  repository_branch = var.release_tag
  service_path      = var.service_path

  # The name is what people read; the slug carries the namespace and is what
  # an installation's channel filter matches.
  service_name      = var.service_name
  service_slug      = coalesce(var.service_slug, var.package_slug)
  link_slugs        = var.link_slugs
  available_links   = var.available_links
  available_actions = var.available_actions

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
