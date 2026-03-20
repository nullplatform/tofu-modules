resource "nullplatform_provider_config" "vpc" {
  provider   = nullplatform
  nrn        = var.nrn
  type       = "aws-networking-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    vpc = {
      id              = var.vpc_id
      subnets         = var.vpc_subnets
      security_groups = var.vpc_security_groups
    }
    load_balancer = {
      public  = {}
      private = {}
    }
  })
  lifecycle {
    ignore_changes = [attributes]
  }
}
