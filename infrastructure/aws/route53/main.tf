resource "aws_route53_zone" "public_zone" {
  name = var.domain_name
}

resource "aws_route53_zone" "private_zone" {
  name = var.domain_name
  vpc {
    vpc_id = var.vpc_id
  }
}

module "aws_route53_acm" {
  source                    = "../acm"
  domain_name               = var.domain_name
  zone_id                   = aws_route53_zone.public_zone.id
  subject_alternative_names = []
}
