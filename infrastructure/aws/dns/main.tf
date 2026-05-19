check "deprecated_module" {
  assert {
    condition     = false
    error_message = "DEPRECATED: infrastructure/aws/dns is deprecated and will be removed in a future release. Please migrate to the replacement module."
  }
}

resource "aws_route53_zone" "public_zone" {
  name          = var.domain_name
  force_destroy = false
}

resource "aws_route53_zone" "private_zone" {
  name          = var.domain_name
  force_destroy = false
  vpc {
    vpc_id = var.vpc_id
  }
}

/*module "aws_route53_acm" {
  source                    = "../acm"
  domain_name               = var.domain_name
  zone_id                   = aws_route53_zone.public_zone.id
  subject_alternative_names = []
}*/
