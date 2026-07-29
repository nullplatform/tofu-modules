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
