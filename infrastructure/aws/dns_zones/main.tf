resource "aws_route53_zone" "public_zone" {
  count         = var.enable_public_zone ? 1 : 0
  name          = var.domain_name
  force_destroy = false
}

resource "aws_route53_zone" "private_zone" {
  count         = var.enable_private_zone ? 1 : 0
  name          = var.domain_name
  force_destroy = false
  vpc {
    vpc_id = var.vpc_id
  }
}