################################################################################
# Installation of a published service package
#
# Everything an organization needs on the nullplatform side to use a service
# package published by another organization: the installation, and the agent
# channel that routes the service's actions to the package worker. The
# service's cloud permissions are not here: each service repository creates
# them with its own requirements module, next to this one.
################################################################################
module "installation" {
  source = "../package_installation"

  nrn             = var.nrn
  package_slug    = var.package_slug
  package_version = var.package_version
  visible_to      = var.visible_to
}

# package-exec to the package worker, filtered to the service's specification.
module "agent_channel" {
  source = "../service_definition_agent_association"

  nrn                        = var.nrn
  description                = coalesce(var.channel_description, "${var.package_slug} package worker")
  tags_selectors             = var.agent_tags_selectors
  channel_sources            = var.channel_sources
  service_specification_slug = coalesce(var.service_specification_slug, var.package_slug)
  worker_orchestrator        = true
  package_slug               = var.package_slug
  entrypoint                 = var.entrypoint

  # The channel routes nothing until the specification is reachable at nrn.
  depends_on = [module.installation]
}
