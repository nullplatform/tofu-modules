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

  # `vpc` is ignored after creation so that additional associations managed by
  # `aws_route53_zone_association` (e.g. cross-account hub-and-spoke setups) do
  # not appear as drift on every plan. The inline `vpc` block above is still
  # required at creation time because AWS rejects private zones with zero VPC
  # associations.
  #
  # This is the pattern explicitly documented by the AWS provider:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association
  lifecycle {
    ignore_changes = [vpc]
  }
}