locals {
  # `load_balancer` is optional in the "aws-networking-configuration" schema
  # (only `vpc` is required) and its own description states at least one of
  # public/private must be set — sending it as {public = {}, private = {}}
  # when unconfigured is meaningless to the API, which never persists it back,
  # causing perpetual drift. Omit the whole key unless there's real content.
  load_balancer_configured = length(var.load_balancer.public) > 0 || length(var.load_balancer.private) > 0
}

resource "nullplatform_provider_config" "vpc" {
  provider   = nullplatform
  nrn        = var.nrn
  type       = "aws-networking-configuration"
  dimensions = var.dimensions
  attributes = jsonencode(merge(
    {
      vpc = {
        id              = var.vpc_id
        subnets         = var.vpc_subnets
        security_groups = var.vpc_security_groups
      }
    },
    local.load_balancer_configured ? {
      load_balancer = {
        public  = var.load_balancer.public
        private = var.load_balancer.private
      }
    } : {}
  ))
}
